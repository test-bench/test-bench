require_relative './automated_init'

context "Activate" do
  receiver = Object.new

  session = Session::Substitute.build

  TestBench.activate(receiver, session: session)

  test "Extends fixture module onto receiver" do
    assert(receiver.is_a?(Fixture))
  end

  test "Extends deactivation variants (_test, _context) onto receiver" do
    assert(receiver.is_a?(DeactivationVariants))
  end

  test "Test session dependency is configured" do
    assert(receiver.test_session.equal?(session))
  end
end
