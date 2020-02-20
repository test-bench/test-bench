Recipes
=======

Using TestBench Without Activation
----------------------------------

TestBench can be used without activating the library. Test scripts just need to wrap test code in a block given to `TestBench.evaluate`:

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

Randomizing the Execution Order
-------------------------------

TestBench executes test files as soon as they are loaded, and thus the tests within cannot be reordered. However, the execution order of the test files themselves _can_ be randomized with a bit of shell scripting. The `find` command line utility can scan the test directory for test files and print them to the standard output device ("stdout"). On Linux, the `shuf` command from coreutils can randomize the order of any text piped into it. Note that on OSX, the coreutils package must be installed via e.g. homebrew, and the command will likely be aliased to `gshuf`. Finally, the `bench` executable can execute file names fed in through a pipe. Combining `find`, `shuf`, and `bench` will allow execution order to be randomized:

- - -

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

Re-run Failed Tests
-------------------

Changing TestBench's Output Device
----------------------------------

TestBench's output device can be set via `TestBench.output=` in `test/test_init`. For example:

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
