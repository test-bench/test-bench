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

```
# Linux
> find test/automated -name '*.rb' | shuf | bench

# OSX
> find test/automated -name '*.rb' | gshuf | bench
```

Parallel Test Execution
-----------------------

While TestBench's runner cannot execute tests in parallel, parallel test execution can be achieved by invoking multiple runners, and feeding each runner with a different segment of the test files. The `find` command line utility can scan the test directory for test files and print them to the standard output device ("stdout"). `awk` can then be used to split the output of `find` into segments. Finally, the `bench` executable can execute file names fed in through a pipe. Combining `find`, `awk`, and `bench` will allow execution to be made parallel:

```
# Run one half of the test files under test/automated
> find test/automated -name '*.rb' | awk 'NR % 2 == 0' | bench

# Run the other half of the test files under test/automated
> find test/automated -name '*.rb' | awk 'NR % 2 == 1' | bench
```

Note that the above examples will need to be run in parallel. A single shell script could run them in the background, and then wait for each segment to finish:

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

TestBench's output device can be set via `TestBench.output=` in e.g. `test/test_init`. For example:

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
