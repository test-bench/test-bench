require_relative './automated_init'

context "Activate" do
  receiver = Object.new

  session = Session.new

  TestBench.activate(receiver, session:)

  test "Extends fixture module onto receiver" do
    assert(receiver.is_a?(Fixture))
  end

  test "Test session dependency is configured" do
    assert(receiver.test_session.equal?(session))
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
