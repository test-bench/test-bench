require_relative 'automated_init'

context "Session" do
  original_session = TestBench::Session.instance

  established_session = TestBench::Session.new
  TestBench::Session.establish(established_session)

  session = TestBench.session

  test "Is the established session" do
    assert(session.equal?(established_session))
  end

ensure
  if not original_session.nil?
    TestBench::Session.establish(original_session)
  end
end
