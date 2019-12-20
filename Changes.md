Changes
=======

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
