require_relative './automated_init'

context "Evaluate" do
  context do
    block_context = nil

    run = Run::Substitute.build

    TestBench.evaluate(run: run) do
      block_context = self
    end

    test "Executes the given block" do
      refute(block_context.nil?)
    end

    test "Executes block in the context of a fixture" do
      assert(block_context.is_a?(Fixture))
    end
  end

  context "Pass" do
    run = Run::Substitute.build

    return_value = TestBench.evaluate(run: run) do
      assert(true)
    end

    test "Return value" do
      assert(return_value == true)
    end
  end

  context "Failure" do
    run = Run::Substitute.build

    return_value = TestBench.evaluate(run: run) do
      assert(false)
    end

    test "Return value" do
      assert(return_value == false)
    end
  end
end
