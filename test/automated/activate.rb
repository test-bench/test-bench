require_relative './automated_init'

context "Activate" do
  receiver = Object.new

  session = Session.new

  session_store = Session::Store.new
  session_store.put(session)

  TestBench.activate(receiver, session_store:)

  test "Extends fixture module onto receiver" do
    assert(receiver.is_a?(Fixture))
  end

  context "Test session dependency is configured" do
    configured = receiver.test_session.equal?(session)

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
