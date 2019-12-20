Recipes
=======

* [Running All Tests in a Single Directory](#running-all-tests-in-a-single-directory)
* [Using TestBench Without Monkey Patching](#using-testbench-without-monkey-patching)
* [Randomizing the Execution Order](#randomizing-the-execution-order)
* [Parallel Test Execution](#parallel-test-execution)
* [Changing TestBench's Output Device](#changing-testbenchs-output-device)
* [Re-run Failed Tests](#re-run-failed-tests)

Running Tests in a Single Directory
-----------------------------------

The `bench` executable can run all tests in a single directory. If TestBench is installed globally, invoke `bench` directly in your shell:

```
> bench test/automated/some_directory/
```

In cases where gems are installed locally within a project, the `bench` executable must be run from wherever the project installs executable files for gems. For instance:

```
> ./gems/bin/bench test/automated/some_directory
```

Using TestBench Without Monkey Patching
---------------------------------------

TestBench can be used without _activating_ the library. Activating TestBench causes Ruby's `main` object, the Ruby _runner_, to be modified, or _monkey patched_.

To use TestBench without activating it, wrap test code in an outer `TestBench.evaluate` block.

```ruby
# Begin test/automated/example.rb

require_relative './automated_init'

TestBench.evaluate do
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
end

# End test/automated/example.rb
```

TestBench doesn't modify Ruby's `Object` class. It modifies Ruby's `main` object, which is vastly less harmful and almost always benign. The `main` object is just the runner object where Ruby executes script files. Adding TestBench's rather small API to the runner is extremely unlikely to cause the problems experienced when test frameworks presume to modify `Object`, `BasicObject`, or `Kernel`, which causes sweeping changes to the entire Ruby environment, and all the classes and objects within it.

Randomizing the Execution Order
-------------------------------

TestBench executes test files as soon as they are loaded. The load order, and thus the execution order, is Ruby's decision to make. However, your operating system already has facilities for changing the order of execution, and thus such features don't belong in a test framework.

Using the operating system to do the work that belongs in the operating system also gives you an opportunity to learn a little bit more about using your operating system.

The `bench` executable can execute file names fed in through a pipe, as any good Unix program should. Combining `find`, `shuf`, and `bench` randomizes the execution order.

```
# Linux
> find test/automated -name '*.rb' | shuf | bench

# OSX
> find test/automated -name '*.rb' | gshuf | bench
```

The `find` command line utility scans the test directory for test files and prints them to the standard output device ("stdout"). That list of files is then piped to the `shuf` command, which randomizes, or _shuffles_, the order of any text piped into it.

The `shuf` utility is part of the standard [`coreutils`](https://www.gnu.org/software/coreutils/coreutils.html) package.

Mac OS users can install `coreutils` via [Homebrew](https://formulae.brew.sh/formula/coreutils) (or any other package manager that provides a `coreutils` distribution). On Mac OS, the `shuf` command is called `gshuf`.

Parallel Test Execution
-----------------------

TestBench's runner doesn't execute tests in parallel. As with [randomized execution order](#randomizing-the-execution-order), parallelization is a responsibility that the operating system already provides.

The `bench` executable can execute file names fed in through a pipe, as any good Unix program should. Combining `find`, `awk`, and `bench` executes subsets of test files in parallel:

```
# Run one half of the test files under test/automated
> find test/automated -name '*.rb' | awk 'NR % 2 == 0' | bench

# Run the other half of the test files under test/automated
> find test/automated -name '*.rb' | awk 'NR % 2 == 1' | bench
```

Parallel test execution is achieved by running multiple test runners in separate native operating system processes, and feeding each runner with a different subset of test files.

The `find` command line utility scans the test directory for test files and prints them to the standard output device ("stdout"). The `awk` command then splits list of files into subsets. Finally, the `bench` command executes the files names fed in through the pipe.

The above examples need to be run in separate terminal windows. A single shell script could run them in the background, and then wait for each segment to finish:

```sh
#!/bin/sh

find test/automated -name '*.rb' | awk 'NR % 2 == 0' | bench &

find test/automated -name '*.rb' | awk 'NR % 2 == 1' | bench &

wait
```

Changing TestBench's Output Device
----------------------------------

TestBench's output device can be set via `TestBench.output=` in `test/test_init.rb`. For example:

```ruby
# Begin test/test_init.rb

# ...

TestBench.output = SomeOutput.new

# End test/test_init.rb
```

Multiple outputs can also be assigned via an array, e.g.:

```ruby
TestBench.output = [TestBench::Output.build, SomeOutput.new]
```

For an idea of how to write custom output devices, mix in the [TestBench::Fixture::Output module](https://github.com/test-bench/test-bench-fixture/blob/master/lib/test_bench/fixture/output.rb).

Re-run Failed Tests
-------------------

A test that sometimes passes and other times fails is a waste of everybody's time, and a likely indicator of a substantial quality deficit in either the implementation, or the test, or both. Therefore, this recipe in particular is meant more to demonstrate TestBench's ability to be extended than to actually solve a real-world problem.

To re-run failed test files, we will have TestBench print out the files that failed to `$stdout`, which we will then pipe into the `bench` command. First, we will need to have TestBench print out the test files that failed. The following script, placed within your project at `script/run-tests-and-print-failures.sh`, run the test files contained in `test/automated` and print the names of files that failed to `$stdout`:

```ruby
#!/bin/sh
#
# Begin script/run-tests-and-print-failures.sh

require 'test_bench'

class PrintFailedTestFiles
  include TestBench::Fixture::Output

  def exit_file(path, result)
    failed = result ? false : true

    $stdout.puts(path) if failed
  end
end

TestBench.output = PrintFailedTestFiles.new

TestBench::Run.('test/automated')

# End script/run-tests-and-print-failures.sh
```

The above script can be connected to `bench` via a pipe:

```
> ./script/run-tests-and-print-failures.sh | bench
```

By replacing TestBench's output with an implementation that prints the test files that failed, the script produces output that can be fed into `bench`. If all the tests pass the first time, `bench` won't run any files, but will still exit successfully.
