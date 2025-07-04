require_relative 'automated_init'

context "Activate" do
  receiver = Object.new

  TestBench.activate(receiver)

  test "Extends fixture module onto receiver" do
    assert(receiver.is_a?(TestBench::Fixture))
  end

  context "Test session dependency is configured" do
    configured = receiver.test_session.equal?(TestBench::Session.instance)

    test do
      assert(configured)
    end
  end

  context "Deactivation Variants" do
    test "_context" do
      assert(receiver.respond_to?(:_context))
    end

    test "_test" do
      assert(receiver.respond_to?(:_test))
    end
  end
end
