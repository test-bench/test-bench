require_relative '../automated_init'

context "Evaluate" do
  original_session = TestBench::Session.instance

  block_context = nil

  session = TestBench::Session.new
  TestBench.evaluate(session:) do
    block_context = self
  end

  test "Executes the given block" do
    refute(block_context.nil?)
  end

  test "Executes block in the context of a fixture" do
    assert(block_context.is_a?(TestBench::Fixture))
  end

  context "Original Session" do
    established_session = TestBench::Session.instance

    restored = established_session == original_session

    test "Restored" do
      assert(restored)
    end
  end
end
