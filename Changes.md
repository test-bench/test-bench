Changes
=======

### 2.0.0.0 - Wed Jul 26 2023

* Testing DSL:
  - Exceptions always crash Ruby, there is now no longer any special handling or formatting of uncaught exceptions
  - Assert and Refute raise a TypeError unless the value is `nil`, `true`, or `false`
  - New variation of the fixture method: `fixture(some_object)`
    - Causes TestBench to resolve a `Fixture` module for `some_object`, and then extend it (and TestBench::Fixture) onto the object at runtime
  - `context!` has been introduced as a complement to `test!`
  - `detail` and `comment` now support text that spans multiple lines (identified by a terminating newline character). They will indent each line of text and prefix with `> `
    - Also, `detail` and `comment` support an optional heading as the first argument that is useful in conjunction with comment text that spans multiple lines

* Fixture Development:
  - When testing fixtures, path matching for context and test titles has improved. Predicates like e.g. `test_passed?` require the final string
    argument to be the name of the test (or the name of the innermost context if the test has no title). This reduces the number of situations where the
    predicates that target one test, e.g. `one_test_passed?` cannot be used due to more than one test matching.
  - When testing fixtures, the output of a fixture can be captured via `TestBench::Fixture.output(some_fixture)`
    - Will be used by a fixture designed for testing fixtures

* Output:
  - Failures are printed right after the context, in order to ensure an error of some kind is always presented when test files are run with Ruby
  - Experimental synchronous output
    - Enable via `TEST_BENCH_EXPERIMENTAL_OUTPUT=on`
    - Doesn't buffer the output on file boundaries; instead, it prints out pending output immediately with gray instead of green or red, and overwrites the text with
      green or red when the result is known

* Batch Runner:
  - Exclude file pattern is now a glob, rather than a Regular expression
  - Runner can be invoked multiple times, so that, for example, UI tests can be run only after the rest of the tests pass

* Random Generator:
  - Introduced TestBench::Random, which provides psuedorandom primitives like `.string`, `.integer`, and `.float`

* Environment Variable Changes:
  - (new) `TEST_BENCH_ONLY_FAILURE`: Show a file's output only when if the file contains a failure
  - (new) `TEST_BENCH_SEED`: Control's TestBench's pseudorandom generator, `TestBench::Random`
  - (new) `TEST_BENCH_EXPERIMENTAL_OUTPUT`: Activates an experimental synchronous output mechanism
  - (changed) `TEST_BENCH_EXCLUDE_FILE_PATTERN`:
    - Now a wildcard pattern, rather than a regular expression
    - Example of a common pattern used in [Eventide](https://eventide-project.org) projects: `/_|sketch|(_init\.rb|_tests\.rb)\z`
    - Same example as a wildlcard pattern: `{_*,*sketch*,*_init,*_tests}.rb`
  - (removed) `TEST_BENCH_ABORT_ON_ERROR`: Use `TEST_BENCH_ONLY_FAILURE` to locate failures
  - (removed) `TEST_BENCH_OMIT_BACKTRACE_PATTERN`: Backtrace filtering is no longer supported, see Ruby's own `--backtrace-limit`
  - (removed) `TEST_BENCH_FAIL_DEACTIVATED_TESTS`: The CLI and batch runner will only return a successful result if no tests or contexts are skipped

### 1.2.0.9 - Sat May 07 2021

* TestBench::Run.(), when given both a block argument and a session, sets the global session (TestBench.session) during the block. The original session is restored after the block is finished executing.

### 1.2.0.8 - Tue May 18 2021

* Added a variant of the `test` method, `test!`, that aborts the execution of the current context if the test fails. Useful, for instance, for assuring that an HTTP response was successful before making any further assertions about the contents of the HTTP response.
* Titles of test failures are now printed in bold, in addition to red.

### 1.2.0.7 - Tue Apr 27 2021

* Detail CLI argument (`--detail` and `--no-detail`) no longer accepts an optional argument

### 1.2.0.6 - Mon Apr 05 2021

* CLI (`bench`) and batch runner (`TestBench::Run`) respect `TEST_BENCH_EXCLUDE_FILE_PATTERN` when files are specified, and not just directories

### 1.2.0.5 - Tue Aug 11 2020

* Gem summary update (no code change)

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

### 2.2.1 - Tue Mar 10 2019

* The CLI (`TestBench::CLI`) now reads from `$stdin` if and only if `$stdin` is a pipe. Previously, it made the determination if `$stdin` is a TTY.

### 2.2.0 - Sun Mar 8 2019

* The runner, `Run`, has been moved from the CLI namespace (`TestBench::CLI::Run`) to the toplevel TestBench namespace (`TestBench::Run`)
* The output subsystem has been reworked. The environment variable `TEST_BENCH_VERBOSE` has been removed and its functionality replaced with `TEST_BENCH_OUTPUT_LEVEL`, which can be set to one of the following: `none`, `summary`, `failure`, `pass`, or `debug`. The `debug` level behaves the way that `TEST_BENCH_VERBOSE` used to.
* The CLI executable, `bench`, has been added back to the project.

### 2.1.1 - Thu Dec 19 2019

* Test files and subdirectories found within directories are sorted by the CLI before being loaded.

### 2.1.0 - Wed Oct 17 2019

* The CLI accepts all of the settings as keyword arguments. Settings supplied to the CLI in this manner will be displayed as the default values by the CLI help text. This allows the CLI settings to be customized on a per-project basis, similar to a per-project configuration file.
* The CLI::Run class accepts the `exclude_file_pattern` setting as a keyword argument.
* The output methods `enter_assert_block` and `exit_assert_block` are now supplied the caller location of the corresponding assertion.
* A bug was fixed in the output implementation that would fail to print outer assertion failures from a block-form assert when the abort on error setting is active.

### 2.0.0 - Tue Oct 15 2019

The changes from TestBench 1 are too numerous to enumerate. See [Changes From TestBench v1 To TestBench v2] for an overview of the most significant changes.

[Changes From TestBench v1 To TestBench v2]: doc/Changes-From-TestBench-1-To-TestBench-2.md
