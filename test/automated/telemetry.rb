require_relative 'automated_init'

context "Telemetry" do
  original_session = Session::Store.get

  session = Session.new
  Session::Store.reset(session)

  control_telemetry = session.telemetry

  telemetry = TestBench.telemetry

  test "Is the session store session's telemetry" do
    assert(telemetry == control_telemetry)
  end

ensure
  if not original_session.nil?
    Session::Store.reset(original_session)
  end
end
