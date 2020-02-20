Changes
=======

### 2.2.0 - ??

* The runner, `Run`, has been moved from the CLI namespace (`TestBench::CLI::Run`) to the toplevel TestBench namespace (`TestBench::Run`)
* The output subsystem has been reworked. The environment variable `TEST_BENCH_VERBOSE` has been removed and its functionality replaced with `TEST_BENCH_OUTPUT_LEVEL`, which can be set to one of the following: `none`, `summary`, `failure`, `pass`, or `debug`. The `debug` level behaves the way that `TEST_BENCH_VERBOSE` used to.
* The CLI executable, `bench`, has been added back to the project. TestBench projects are recommended to use `TestBench::Run.()` in `test/automated.rb`, not `TestBench::CLI.()`. Users should access the CLI via the `bench` executable exclusively now.

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
