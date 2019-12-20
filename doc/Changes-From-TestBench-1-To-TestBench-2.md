Changes From TestBench 1 to TestBench 2
=======================================

The most significant changes relevant to end users are outlined in the sections below. In addition, TestBench 2 is a ground-up rewrite, so most of its internals have likely changed. The only breaking change to the core testing DSL has been to assert's block-form.

Telemetry
---------

* TestBench 2 no longer publishes telemetry. The core TestBench methods such as `context`, `test` and `assert` all push directly to the output device.

Block-form of Assert
--------------------

* There is no longer any notion of an assertion "subject" (which was the positional parameter). Consequently, the block form of `assert` no longer accepts a positional argument and TestBench no longer extends `Assertions` modules onto anything.
* The new purpose of block-form assertions is to enable rich assertion failure output, similar to RSpec matchers or assertions in Minitest like `assert_equals`. For an example, see the new assertion method `assert_raises`; when `assert_raises` passes, no output is written, but when it fails, the error that was expected is shown (along with what errors, if any, _were_ raised).
* Unlike, for instance, RSpec matchers, a separate API isn't necessary for building custom assertions. Instead, custom assertions rely on the same testing DSL as the rest of TestBench; their output comes from e.g. `context`, `test`, `comment`, etc.
* Assertion blocks only pass if at least one assertion is made within the block, and they no longer concern themselves with the return value of the given block.

Assert Raises
-------------

* In TestBench 1, the proper form for testing whether some code raises an assertion is `assert(proc { ... }) { raises_error?(SomeError) }`.
* In TestBench 2, use `assert_raises(SomeError) { ... }`
* There is also a `refute_raises` to correspond with `refute(proc { ... }) { raises_error?(SomeError) }`
* When `assert_raises` or `refute_raises` fail, helpful diagnostic information is printed to the terminal (made possible by the new block-form of `assert` behind the scenes)

Fixtures
--------

* A new DSL method, `fixture`, has been added, which executes Fixture classes. Example: `fixture(SomeFixture, :some_arg, :other_arg)` instead of e.g. `SomeFixture.(:some_arg, :other_arg)` as before. The latter will still execute, but its test results won't effect the overall test run. This change is so that fixtures themselves can be tested in a manner that is isolated from the surrounding test suite. More documentation on this to come.
* Fixture classes that implement `#call` do not require a block argument to be given to `fixture`. Fixture classes that do _not_ require a block, e.g. `fixture(SomeFixture) { ... }`

Environment Variables
---------------------

The following environment variables are no longer used by TestBench:

* `TEST_BENCH_COLOR` - TestBench's terminal output now includes additional styling beyond colors, such as bold or italic text. Therefore, the variable has been renamed to `TEST_BENCH_OUTPUT_STYLING`
* `TEST_BENCH_EXCLUDE_PATTERN` - Renamed to `TEST_BENCH_EXCLUDE_FILE_PATTERN`
* `TEST_BENCH_RECORD_TELEMETRY` - TestBench no longer records telemetry
* `TEST_BENCH_QUIET` - To disable terminal output, set `TEST_BENCH_OUTPUT_LEVEL` to `none`
* `TEST_BENCH_VERBOSE` - To show verbose output, set `TEST_BENCH_OUTPUT_LEVEL` to `debug`
* `TEST_BENCH_TESTS_DIR` - Renamed to `TEST_BENCH_TESTS_DIRECTORY`
* A new environment variable has been added, `TEST_BENCH_OMIT_BACKTRACE_PATTERN`, which allows backtraces to be abridged.
* A second new environment variable has been added, `TEST_BENCH_OUTPUT_LEVEL`, can be set to `none`, `summary`, `failure`, `pass`, or `debug`

Activation
----------

* In TestBench 1, there was a special loader file that would also call `TestBench.activate`. It could be loaded via `require "test_bench/activate"`. This loader has been removed; just use `require "test_bench"; TestBench.activate'`.
