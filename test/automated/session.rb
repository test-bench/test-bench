require_relative 'automated_init'

context "Session" do
  original_session = Session::Store.get

  control_session = Session.new
  Session::Store.reset(control_session)

  session = TestBench.session

  comment session.class.inspect

  test "Is the session store's session" do
    assert(session == control_session)
  end

ensure
  if not original_session.nil?
    Session::Store.reset(original_session)
  end
end
