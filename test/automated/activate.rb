require_relative './automated_init'

context "Activate" do
  receiver = Object.new

  run = Run::Substitute.build

  TestBench.activate(receiver, run: run)

  test "Extends fixture module onto receiver" do
    assert(receiver.is_a?(Fixture))
  end

  test "Extends underscore variants onto receiver" do
    assert(receiver.is_a?(Fixture::UnderscoreVariants))
  end

  test "Test run dependency is configured" do
    assert(receiver.test_run.equal?(run))
  end
end
