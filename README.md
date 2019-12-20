TestBench
=========

TestBench is a no-nonsense testing framework for Ruby aiming to offer precisely what is needed to test well-designed code effectively and easily. In stark contrast to most other testing frameworks, test files are written using a procedural API, not a declarative one, which brings a score of substantial benefits in exchange for largely immaterial drawbacks. As a result, TestBench can be learned very quickly. However, users should not expect it to offer many palliative features that ease the difficulties inherent to working with vast, long-running, or brittle test suites. With that in mind, even those situations can usually be addressed with a little improvising.

Installation
------------

To install TestBench with Rubygems:

```
> gem install test_bench
```

Or, add it to a project's `Gemfile` if using Bundler:

```ruby
gem 'test_bench', group: :development

# - OR -

group :development do
  gem 'test_bench'
end
```

Next, place a test initialization file at `test/test_init.rb`:

```ruby
# Begin test/test_init.rb

# Load the code to be tested
require_relative '../lib/my/code.rb'

# Load Test Bench and then activate it
require 'test_bench'; TestBench.activate

# End test/test_init.rb
```

The first significant line of code loads TestBench and then "activates" it, making its core DSL available to test files. For those concerned about modifying the Ruby runtime (i.e. "monkeypatching"), activating TestBench [isn't strictly necessary][1]. The second significant line of code loads the code that is to be tested. It does not matter to TestBench how the code is loaded.

Test files can be added once a test initialization file is added to the project. The most common location where TestBench users place automated test files is within the `test/automated` directory. For instance, the following file could be placed at `test/automated/example.rb`:

```ruby
# Begin test/automated/example.rb

require_relative '../test_init'

context "Example Context" do
  test "Pass" do
    assert(true)
  end

  test "Assertion failure" do
    assert(false)
  end

  test "Error" do
    fail "Some error"
  end
end

# End test/automated/example.rb
```

Running Test Files
------------------

Individual test files are most commonly run via the `ruby` executable:

```
> ruby test/automated/example.rb 
Example Context
  Pass
  Assertion failure
    test/automated/example.rb:9:in `block (2 levels) in <main>': Assertion failed (TestBench::Fixture::AssertionFailure)
  Error
    test/automated/example.rb:13:in `block (2 levels) in <main>': Some error (RuntimeError)
	    *omitted*
	    from test/automated/example.rb:12:in `block in <main>'
	    *omitted*
	    from test/automated/example.rb:3:in `<main>'

```

However, the ruby executable can only run an individual file, so a test runner is therefore needed run multiple files or an entire test suite. Before TestBench's runner can be used, however, it must be added to the project. The most common way to do this is to add a ruby file, usually at `test/automated.rb`, that invokes the runner:

```ruby
# Begin test/automated.rb

TestBench::Run.('test/automated')

# End test/automated.rb
```

The above runner will run all tests under the `test/automated` directory (which, at present, only contains the one test file, `example.rb`, added above).

```
> ruby test/automated.rb
Running test/automated/example.rb
Example Context
  Pass
  Assertion failure
    test/automated/example.rb:9:in `block (2 levels) in <top (required)>': Assertion failed (TestBench::Fixture::AssertionFailure)
  Error
    test/automated/example.rb:13:in `block (2 levels) in <top (required)>': Some error (RuntimeError)
	    *omitted*
	    from test/automated/example.rb:12:in `block in <top (required)>'
	    *omitted*
	    from test/automated/example.rb:3:in `<top (required)>'
	    *omitted*
	    from test/automated.rb:5:in `<main>'

Error Summary:
   2: test/automated/example.rb
      test/automated/example.rb:9:in `block (2 levels) in <top (required)>': Assertion failed (TestBench::Fixture::AssertionFailure)
      test/automated/example.rb:13:in `block (2 levels) in <top (required)>': Some error (RuntimeError)

Finished running 1 file
Ran 3 tests in 0.001s (3000.0 tests/second)
1 passed, 0 skipped, 2 failed, 2 total errors

```

The TestBench library also provides an executable file, `bench`. It can be used to run individual test files or directories containing test files (just like the previously mentioned runner). To run a single test file, supply the path as a command line argument:

```ruby
> bench test/automated/example.rb 

> bench test/automated/some_directory/
```

By default, when run with no arguments, the CLI will run all the test files under `test/automated`. This can be altered to any directory of your choosing by setting the environment variable `TEST_BENCH_TESTS_DIRECTORY`.

Finally, test files and directories can be piped into the CLI via standard input ("stdin"):

```
> echo "test/automated/example.rb" | bench

> echo "test/automated/some_directory" | bench
```

The CLI also accepts command-line switches that configure how TestBench operates. Each of the switches also has a corresponding environment variable which allows for TestBench to be configured for a local development environment. Invoking the CLI with the `--help` or `-h` arguments will cause the CLI to print documentation on each switch and then exit.

Writing Tests
-------------

TestBench contains just five core methods: `context`, `test`, `assert`, `comment`, and `fixture`. Other methods, such as `refute`, are built in terms of the core methods.

### Context and Test

The `context` method establishes a context around a block of test code. The blocks given to `context` can further divide the test file into sub-contexts. Ruby's lexical scoping allows variables defined in outer contexts to be available within nested contexts. Tests are titled blocks of code that perform assertions (typically one per test). Titles are optional for both contexts and tests. Contexts without a title serve solely as lexical scopes and do not effect the test output in any way; nothing is printed and the indentation is not changed. Tests without titles are treated similarly, but if a test fails, a title of `Test` is used to indicate the test failure. Also, both contexts and tests can also be skipped by omitting the block argument.

As a convenience, TestBench includes the methods `_context` and `_test` which skip the context or test (respectively) regardless of whether a block is given. They are useful to temporarily disable a context or test, but should not ever be used in a finished test file.

### Comments

With TestBench, test file output is intended to be read by users. Often, the text printed by `context` and `test` sufficiently expresses what behavior the tests are expecting out of the test subject. However, comments can also be included in test code in order to provide the user with additional output:

```ruby
context "Some Context" do
  comment "Some comment"
  comment "Other comment"

  # ...
end
```

### Assertions

TestBench offers four assertion methods: `assert`, `refute`, `assert_raises`, and `refute_raises`.

#### Assert and Refute

The `assert` and `refute` methods accept a single positional parameter. An `AssertionFailure` error is raised by both methods based on whether the value of the positional parameter is `nil` or `false`:

```ruby
assert(1 == 1)             # Passes
assert(some_object.nil?)   # Passes if some_object is nil
refute(1 != 1)             # Passes
refute(!some_object)       # Passes if some_object is *not* nil

assert(1 > 1)              # Fails
refute(true)               # Fails
```

#### Assert and Refute Raises

To test that a block of code raises an error, use `assert_raises`. It can be called with no arguments, in which case the given block must raise a `StandardError` of some kind. If a class is given as the first positional parameter, the block must raise an instance of the given class. The block cannot raise a subclass of the given class; to permit the block to raise a subclass, supply the keyword argument `strict: false`. A string can also be given as the second positional parameter, which is an error message that the exception raised by the block must match precisely.

When the given block raises an error that is not the class given to `assert_raises`, the error is _not_ rescued by `assert_raises`. Such an error was not anticipated by the test, and thus is not treated any different than any other error.

```ruby
# Passes
assert_raises do
  raise "Some error message"
end

# Passes
assert_raises(KeyError) do
  {}.fetch(:some_key)
end

# Passes
assert_raises(RuntimeError, "Some error message") do
  raise "Some error message"
end

# Fails
assert_raises do
end

# Does not pass or fail; the error raised by the block is not rescued
# by assert_raises, because it does not match the given class.
assert_raises(ArgumentError) do
  raise RuntimeError
end

# Like the above example, the error raised by the block is not
# rescued. Even though the block raises a KeyError, which is a
# subclass of IndexError, assert_raises is strict about errors being
# an instance of the given class (and not a subclass).
assert_raises(IndexError) do
  {}.fetch(:some_key)
end

# Passes because the strictness is relaxed
assert_raises(IndexError, strict: false) do
  {}.fetch(:some_key)
end

# Fails; error messages do not match precisely
assert_raises(RuntimeError, "Other error message") do
  raise "Some error message"
end
```

The `refute_raises` method complements `assert_raises`. When no argument is given, the block is expected to _not_ raise a `StandardError` of any kind. When a class is given as an argument, the block must not raise an error of the given class. Similar to `assert_raises`, if the block raises an error that is not an instance of the given class, the error is not rescued by `refute_raises` at all. Unlike its counterpart, however, `refute_raises` does not accept a second message argument.

```ruby
# Passes
refute_raises do
end

# Fails
refute_raises do
  raise "Some error message"
end

# Passes
refute_raises(KeyError) do
end

# Fails
refute_raises(KeyError) do
  {}.fetch(:some_key)
end

# Does not pass or fail; the error raised by the block is not rescued
# by assert_raises, because it does not match the given class.
refute_raises(ArgumentError) do
  raise RuntimeError
end

# Like the above example, the error raised by the block is not
# rescued. Even though the block raises a KeyError, which is a
# subclass of IndexError, refute_raises is strict about errors being
# an instance of the given class (and not a subclass).
refute_raises(IndexError) do
  {}.fetch(:some_key)
end

# Assertion failure, unlike above, because the strictness is relaxed
refute_raises(IndexError, strict: false) do
  {}.fetch(:some_key)
end
```

As is evident from the examples, `assert_raises` and `refute_raises` have _three_ possible outcomes, not two: they can pass, they can fail, or they can surface any error they didn't anticipate.

#### Block-form Assertions

The block-form assertion builds on the basic TestBench features to provide domain-specific assertions composed of lower-level assertions, as well as context blocks, test blocks, comments, and all other basic TestBench features.

In addition to its more basic form, `assert` can also take an optional block containing test code. All of TestBench’s facilities can be used inside a block-form assertion, including `context`, `test`, `assert`, `refute`, `comment`, etc. All tests performed by the block must pass in order to satisfy the assertion.

By default, any test output produced by the block is printed only when the assertion fails, allowing the block to convey useful details about the failure.

When a block is passed to `assert`, a positional argument must not be passed along with it.

The block given to a block-form assertion must perform at least one assertion, otherwise the block will fail.

TestBench itself uses block-form assertions to compose the `assert_raises` and `refute_raises` assertions.

An example of a block-form assertion:

```ruby
context "Block-form Assertion Example" do
  def assert_json(string)
    assert do
      comment "Assert JSON: #{string.to_s[0..100]}"

      assert(string.is_a?(String))

      test "Can be parsed as JSON" do
        refute_raises(JSON::ParserError) do
          JSON.parse(string)
        end
      end
    end
  end

  test "Pass" do
    assert_json('{ "someKey": "some-value" }')
  end

  test "Failure" do
    assert_json('not-a-json-document')
  end
end
```

In the above example, an assertion failure location would not refer to the correct source code file and line number. An optional caller_location keyword argument can be passed to the assertion to specify the actual failure location.

```ruby
def assert_json(string, caller_location: nil)
  caller_location ||= caller_locations.first

  assert(caller_location: caller_location) do
    # ...
  end
end
```

Here is the output of running the above test. Notice that, while the passing test case prints no output, the failing test case prints out detailed failure information:

```
Block-form Assertion Example
  Pass
  Failure
    test/automated/block_form_assertions/example.rb:7:in `assert_json': Assertion failed (TestBench::Fixture::AssertionFailure)
      Assert JSON: not-a-json-document
        Prohibited Error: JSON::ParserError (strict)
        Raised Error: #<JSON::ParserError: 767: unexpected token at 'not-a-json-document'>
      Can be parsed as JSON
        test/automated/block_form_assertions/example.rb:13:in `block (2 levels) in assert_json': Assertion failed (TestBench::Fixture::AssertionFailure)

```

The block-form of assert allows TestBench to offer detailed assertion failure output similar to other testing frameworks, but it offers two significant advantages over them:

1. Specialized assertions are implemented using the same interface that TestBench users already know (versus, for instance, RSpec’s matcher API which is entirely separate from its testing DSL)
2. Output from block-form assertions can be printed even when the assertions pass, by setting the output level to debug, either via passing `--output-level debug` to the bench executable, or by setting the `TEST_BENCH_OUTPUT_LEVEL` environment variable to `debug`.

Fixtures
--------

To allow for generalized test abstractions, the TestBench core methods (`context`, `test`, `assert`, `refute`, `comment`, etc.) can be made available to any Ruby class or object. To add the methods to a class, mix in `TestBench::Fixture`:

```ruby
class SomeFixture
  include TestBench::Fixture

  def call
    context "Some Context" do
      test "Example passing test" do
        assert(true)
      end

      test "Example failing test" do
        refute(true)
      end
    end
  end
end
```

NOTE: Early on during the initial development of unit testing, the term "fixture" meant the specialized classes that would test implementation code. In the Ruby community, the term has come to mean test data loaded during the setup phase of tests. TestBench makes use of the original meaning of the term, not the latter.

In the above example, `SomeFixture` can be instantiated like any other Ruby class (`TestBench::Fixture` does not interfere with `#initialize`). Fixture classes can even be tested in isolation:

```ruby
some_fixture = SomeFixture.new

some_fixture.()

test "The example passing test passes" do
  assert(some_fixture.test_session.one_passed?('Example passing test'))
end

test "The example failing test fails" do
  assert(some_fixture.test_session.one_failed?('Example failing test'))
end
```

In order to run a fixture and have its output go to the appropriate place, TestBench includes the `fixture` method, which accepts a fixture class, along with any arguments to be passed to the constructor:

```ruby
context "Other Fixture" do
  class OtherFixture
    include TestBench::Fixture

    def initialize(arg1, arg2)
      # ...
    end

    def call
      # ...
    end
  end

  fixture(OtherFixture, 'some-arg', 'other-arg')
end
```

When a fixture class implements `#call`, `fixture` will invoke the `#call` method after instantiation. The intent of `#call` is to carry out a test procedure, just like a test script. Sometimes it may not makes sense for a fixture class to have a single call method; in such circumstances, a block can be supplied to `fixture` which is executed instead:

```ruby
context "Fixture Block Argument" do
  class YetAnotherFixture
    include TestBench::Fixture

    def initialize(arg1, arg2)
      # ...
    end
  end

  fixture(YetAnotherFixture, 'some-arg', 'other-arg') do
    context "Some Context" do
      test "Some test" do
        assert(true)
      end

      # ...
    end
  end
end
```

One final note on fixtures: fixture classes are designed to be included with libraries, alongside related implementation code. As a result, `TestBench::Fixture` is actually packaged in a separate library, [test_bench-fixture][2], so that such libraries do not have to take a dependency on a testing framework. That library is safe to be packaged with production code, whereas TestBench, being a test framework, does not belong in a typical production system.

Recipes
-------

While TestBench lacks direct support for many features commonly found in other frameworks, it is not generally difficult to add those features with a bit of shell scripting and creativity. See the [Recipes page][3] for more information.

Recent Changes
--------------

For a comprehensive list of changes, see [Changes][4]

### 2.3.3 - Tue Jun 9 2020

* An issue where `refute_raises` (and, likely, `assert_raises`) would erroneously catch unrelated errors is fixed
* Block-form assertions no longer rescue any errors raised by the block. `context` and `test` blocks within a block-form assertion will still handle errors as they do outside of block-form assertions, though
* `TestBench.evaluate` uses `context` for executing the block its given, rather than coupling to an internal method on the test session

### 2.3.2 - Fri Jun 5 2020

* Removed superfluous output when writing to an output device that doesn't support SGR escape codes

### 2.3.1 - Thu Jun 4 2020

* Added `TEST_BENCH_FAIL_DEACTIVATED_TESTS` environment variable and `--permit-deactivated-tests` CLI argument that cause the test run to fail when there are deactivated tests (i.e. `_context` or `_test`). The default behavior is to fail on deactivated tests

### 2.3.0 - Tue May 19 2020

* When $stdin is a pipe, but no data is written, issue warning that no files will be written (reverts change made by v2.2.5)
* Separate block argument given to `TestBench::Run.call` from `TestBench::Run#call` for clarity
* Remove `TestBench::Run#<<`

### 2.2.5 - Tue May 19 2020

* When $stdin is a pipe, but no data is written, run all files under the tests directory (e.g. `test/automated`)

### 2.2.4 - Fri Apr 24 2020

* Tests that don't have a title, and pass, no longer cause an erroneous extra indentation

### 2.2.2 - Fri Apr 24 2020

* Vestigal code in `TestBench::Output::Levels::Pass` is removed

### 2.2.1 - Tue Mar 10 2020

* The CLI (`TestBench::CLI`) now reads from `$stdin` if and only if `$stdin` is a pipe. Previously, it made the determination if `$stdin` is a TTY.

### 2.2.0 - Sun Mar 8 2020

* The runner, `Run`, has been moved from the CLI namespace (`TestBench::CLI::Run`) to the toplevel TestBench namespace (`TestBench::Run`)
* The output subsystem has been reworked. The environment variable `TEST_BENCH_VERBOSE` has been removed and its functionality replaced with `TEST_BENCH_OUTPUT_LEVEL`, which can be set to one of the following: `none`, `summary`, `failure`, `pass`, or `debug`. The `debug` level behaves the way that `TEST_BENCH_VERBOSE` used to.
* The CLI executable, `bench`, has been added back to the project.

License
-------

Test Bench is licensed under the [MIT license][6].

Copyright © Nathan Ladd

[1]: doc/Recipes.md#using-testbench-without-activation
[2]: https://github.com/test-bench/test-bench-fixture
[3]: doc/Recipes.md
[4]: Changes.md
[5]: doc/Changes-From-TestBench-1-To-TestBench-2.md
[6]: MIT-License.txt
