require_relative '../automated_init'

context "Toplevel Context" do
  block_context = nil

  session = Fixture::Session::Substitute.build

  TestBench.context("Some Context", session: session) do
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
