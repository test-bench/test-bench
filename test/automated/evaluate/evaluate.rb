require_relative '../automated_init'

context "Evaluate" do
  block_context = nil

  session = Session.new
  TestBench.evaluate(session:) do
    block_context = self
  end

  test "Executes the given block" do
    refute(block_context.nil?)
  end

  test "Executes block in the context of a fixture" do
    assert(block_context.is_a?(Fixture))
  end
end
