# TestBench

TestBench is a principled test framework for Ruby aiming to offer precisely what is needed to test well-designed code effectively and easily. For more information, visit TestBench's website: [http://test-bench.software](http://test-bench.software).

## Getting Started

### Installation

#### Via RubyGems

``` bash
> gem install test_bench
```

#### Via Bundler

``` ruby
# Gemfile
source 'https://rubygems.org'

gem 'test_bench', group: :development

# Or

group :development do
  gem 'test_bench'
end
```

### Initialize TestBench

Place a test initialization file at test/test_init.rb.

``` ruby
# test/test_init.rb

# Load the code to be tested
require_relative '../lib/my/code.rb'

# Load TestBench
require 'test_bench'

# Activate TestBench
TestBench.activate
```

Activating TestBench with `TestBench.activate` makes the core DSL available in test files.

The effect of activating TestBench is very limited. It adds TestBench's core API methods to Ruby's `main` object, which is the Ruby script runner. Activating TestBench has no effects on any other objects or classes in the Ruby system except for the `main` script runner.

It's not strictly necessary to activate TestBench in order to use it. See the [Using TestBench Without Monkey Patching](/user-guide/recipes.md#use-testbench-without-monkey-patching) recipe for specifics.

### Load the Test Initialization File

At the top of every test file, load the `test_init.rb` file.

``` ruby
# test/automated/some_test.rb

require_relative '../test_init'

context "Some Example" do
  test "Some test" do
    assert(true)
  end
end
```

## Running Tests

TestBench doesn't require the use of any special test runner. It's designed so that tests can be executed using nothing more than Ruby. There's no need to create or maintain plugins for editors or CI servers. It's just Ruby.

### Using the Ruby Executable

Run test files like any script file by passing the file name to the `ruby` command.

```
> ruby test/automated/some_test.rb
Some Context
  Some test
  Some other test
  Some failing test
    test/automated/some_test.rb:13:in `block (2 levels) in <top (required)>': Assertion failed (TestBench::Fixture::AssertionFailure)
```

### Batch Runner

Runs a batch of files and directories.

```ruby
TestBench::Run.(*paths, exclude_file_pattern: nil)
```

Here is an example of the batch runner being invoked from a file named `automated.rb` located in the `test` directory.

```ruby
# test/automated.rb

TestBench::Run.()
```

For more information on the batch runner, visit its [documentation page](http://test-bench.software/user-guide/running-tests.html#batch-runner).

### Command Line Runner

In addition to being able to run tests using the raw `ruby` executable, TestBench also provides it's own command line executable that offers a bit more power.

The `bench` executable can be used to run individual test files or directories containing test files.

#### Running a Single File

To run a single test file, specify the file path as a command line argument.

``` bash
> bench test/automated/some_test.rb
```

#### Running a Directory

To run a directory of test files, and its subdirectories, specify the directory path as a command line argument.

``` bash
> bench test/automated/some_directory/
```

#### Default Test Directory

By default, when the `bench` commend is executed with no arguments, it will run all the test files under `test/automated`.

This default can be changed by setting the environment variable `TEST_BENCH_TESTS_DIRECTORY`.

For more information on the command line runner, visit its [documentation page](http://test-bench.software/user-guide/running-tests.html#command-line-runner).

## Writing Tests

TestBench's core API is just a handful of methods, including `context`, `test`, `assert`, `comment`, `detail`, and `fixture`. Other methods, such as `refute` and `assert_raises` are built in terms of the core methods.

### Context and Test Blocks

The `context` method establishes a context around a block of test code.

``` ruby
context "Some Context" do
  test "Some test" do
    # ...
  end
end
```

The blocks given to `context` can further subdivide the test file into nested, sub-contexts.

#### Nested Contexts

``` ruby
context "Some Context" do
  context "Some Inner Context" do
    test "Some test" do
      # ...
    end
  end
end
```

#### Lexical Scoping

Ruby's lexical scoping allows variables defined in outer contexts to be available within nested contexts, but not available outside of the outer context.

``` ruby
context "Some Context" do
  context "Some Inner Context" do
    some_variable = 'some_value'

    context "Some Deeper Context" do
      puts some_variable
      # => "some_value"
    end
  end

  puts some_variable
  # => NameError (undefined local variable or method `some_variable' for main:Object)
end
```

#### Test Blocks

Tests are titled blocks of code that perform assertions, typically one per test.

``` ruby
context "Some Context" do
  test "Some test" do
    assert(true)
  end

  test "Some other test" do
    assert(true)
  end
end
```

#### Optional Titles

Titles are optional for both contexts and tests. Contexts without a title serve solely as lexical scopes and do not effect the test output in any way; nothing is printed and the indentation is not changed. Tests without titles are treated similarly, but if a test fails, a title of `Test` is used to indicate the test failure. Also, both contexts and tests can also be skipped by omitting the block argument.

``` ruby
context "Some Context" do
  context do
    some_variable = 'some_value'

    test do
      assert(some_variable == 'some_value')
    end
  end

  context do
    some_variable = 'some_other_value'

    test do
      assert(some_variable == 'some_other_value')
    end
  end
end
```

#### Deactivating Contexts and Tests

Contexts and tests can be deactivated by prefixing them with the underscore character: `_context` and `_test`.

They're useful for temporarily disabling a context or test when debugging, troubleshooting, or doing exploratory testing.

``` ruby
context "Some Context" do

  # This context doesn't run
  _context "Some Inner Context" do
    test "Some test" do
      assert(true)
    end
  end

  context "Some Other Inner Context" do

    # This test doesn't run
    _test "Some test" do
      assert(true)
    end
  end
end
```

> **WARNING**: A test run that includes deactivated contexts or tests will fail. A CI build that includes deactivated tests will result in a broken build.
>
> Deactivated tests and contexts should **never** be checked in to version control. Checking in deactivated test code should be seen as a development process failure.
>
> This behavior can be changed by setting the `TEST_BENCH_FAIL_DEACTIVATED_TESTS` environment variable to `off`.

### Comments

Test output is intended to be read by users.

Often, the text printed by `context` and `test` sufficiently expresses what behavior the tests are expecting out of the test.

Comments can also be included in test code in order to provide the user with additional output.

```ruby
context "Some Context" do
  comment "Some comment"
  comment "Other comment"

  # ...
end
```

### Details

When tests fail, it is often necessary to see details of the test scenario itself in order to diagnose the failure. However, it is generally undesirable to see information about the test scenario when reading the output from a test file that passes. For that reason, _detailed_ output can be printed with `detail`:

```ruby
context "Some Context" do
  test "Passing test" do
    detail "Will not be printed"

    assert(true)
  end

  test "Failing test" do
    detail "Will be printed"

    assert(false)
  end
end
```

### Assertions

TestBench offers four assertion methods: `assert`, `refute`, `assert_raises`, and `refute_raises`.

#### Assert and Refute

The `assert` and `refute` methods accept a single parameter. The value of the parameter must either be true or false, or _truthy_.

```ruby
assert(true)               # Passes
assert(false)              # Fails
assert(1 == 1)             # Passes
assert(some_object.nil?)   # Passes if some_object is nil
assert(1 > 1)              # Fails

refute(true)               # Fails
refute(false)              # Passes
refute(1 != 1)             # Passes
refute(!some_object)       # Passes if some_object is *not* nil
```

#### Assert Raises and Refute Raises

To test that a block of code raises an error, use `assert_raises`. To test that a block of code _does not_ raise an error, use `refute_raises`.

Either method takes a block argument, and the respective assertion will either pass or fail based on whether the block raises an error when it's evaluated.

```ruby
# Passes
assert_raises do
  raise 'Some error message'
end

# Fails
assert_raises do

end

# Passes
refute_raises do

end

# Fails
refute_raises do
  raise 'Some error message'
end
```

If a class is given as the first positional parameter, the block must raise an instance of the given class.

```ruby
# Passes
assert_raises(RuntimeError) do
  raise 'Some error message'
end

# Fails
assert_raises(SomeOtherError) do
  raise 'Some error message'
end

# Passes
refute_raises(RuntimeError) do
  raise SomeOtherError
end

# Fails
refute_raises(SomeOtherError) do
  raise SomeOtherError
end
```

To match the raised error's message, the error message can be specified as the second argument.

```ruby
# Passes
assert_raises(RuntimeError, 'Some error message') do
  raise 'Some error message'
end

# Fails
assert_raises(RuntimeError, 'Some error message') do
  raise 'Some other error message'
end
```

Unlike `assert_raises`, `refute_raises` does not accept an optional error message.

For more information on assertions, visit the [documentation page](http://test-bench.software/user-guide/writing-tests.html#assertions).

## Fixtures

To allow for generalized test abstractions, the TestBench core methods (`context`, `test`, `assert`, `refute`, `detail`, `comment`, etc.) can be made available to any Ruby class or object. To add the methods to a class, mix in `TestBench::Fixture`:

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

For more information on fixtures, visit the [documentation page](http://test-bench.software/user-guide/fixtures.html).

## Recent Changes

For a comprehensive list of changes, see [Changes](Changes.md)

### 1.2.0.4 - Tue Aug 11 2020

* Reduced the number of backfills of MRI behavior needed for TestBench to run under MRuby
* Removed use of controls from TestBench::Fixture that used regular expressions, which allows TestBench::Fixture to be used under MRuby without a regular expression library compiled in

### 1.2.0.3 - Sat Aug 8 2020

* Use of `Kernel#warn` is removed since it is not available under MRuby

### 1.2.0.2 - Sat Aug 8 2020

* Project is prepared to support MRuby

### 1.2.0.1 - Sat Aug 8 2020

* An internal use of `Struct` is replaced with a pure class for MRuby compatibility

### 1.2.0.0 - Fri Jul 24 2020

* Deactivated tests no longer cause details to print when there are no actual test errors

### 1.1.0.0 - Fri Jul 24 2020

* Added a Fixture DSL method `#detail` that, by default, is only printed when the surrounding test file fails. Details can either be always shown or always hidden by setting `TEST_BENCH_DETAIL` to `on` or `off`, respectively
* Tests now raise an error when no assertion is made
* Removed block-form assertions; their functionality is now entirely duplicated by tests
* `assert_raises` and `refute_raises` now print their output using `#detail`, not `#comment`
* Removed the output levels (e.g. `none`, `debug`) and the corresponding `TEST_BENCH_OUTPUT_LEVEL` environment variable
* Verbose output, similar to the previous `debug` output level, can be enabled be activated by setting `TEST_BENCH_VERBOSE` to `on`
* The `exclude_file_pattern` keyword argument of `TestBench::Run.()` is renamed to `exclude`
* `fixture` ensures that the given fixture class is a TestBench Fixture and raises an error if it is not
* Session substitute predicates like `commented?` now accept an optional list of context titles, just like e.g. `test_passed?` already does
* Session substitutes allow scoping, so that multiple predicates can match on a section of test output pertaining to the same context:

```ruby
some_context = some_fixture.test_session["Some Context"]

assert(some_context.test_passed?("Some test")) # "Some test" must be within "Some Context"
```

### 1.0.2.0 - Fri Jul 10 2020

* Removed interpretation of `VERBOSE` environment variable

### 1.0.1.0 - Wed Jun 10 2020

* Added `TestBench.context`

### 1.0.0.1 - Wed Jun 10 2020

* When output styling is disabled, the default output disambiguates skipped tests and contexts from passing tests and contexts, respectively

### 1.0.0.0 - Tue Jun 9 2020

* Public release of v1.0.0.0

## License

Test Bench is licensed under the [MIT license](MIT-License.txt)

Copyright © Nathan Ladd
