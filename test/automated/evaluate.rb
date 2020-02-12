require_relative './automated_init'

context "Evaluate" do
  context do
    block_context = nil

    session = Fixture::Session::Substitute.build

    TestBench.evaluate(session: session) do
      block_context = self
    end

    test "Executes the given block" do
      refute(block_context.nil?)
    end

    test "Executes block in the context of a fixture" do
      assert(block_context.is_a?(Fixture))
    end

    test "Deactivation variants (_test, _context) are available in block" do
      assert(block_context.is_a?(DeactivationVariants))
    end
  end

  context "Pass" do
    session = Fixture::Session::Substitute.build

    return_value = TestBench.evaluate(session: session) do
      assert(true)
    end

    test "Return value" do
      assert(return_value == true)
    end
  end

  context "Failure" do
    session = Fixture::Session::Substitute.build

    return_value = TestBench.evaluate(session: session) do
      assert(false)
    end

    test "Return value" do
      assert(return_value == false)
    end
  end
end
