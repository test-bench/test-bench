require_relative 'automated_init'

context "Register Telemetry Sink" do
  telemetry_sink = Controls::TelemetrySink.example

  original_session = Session::Store.get

  session = Session.new
  Session::Store.reset(session)

  TestBench.register_telemetry_sink(telemetry_sink)

  telemetry = session.telemetry

  test "Registered" do
    assert(telemetry.registered?(telemetry_sink))
  end

ensure
  if not original_session.nil?
    Session::Store.reset(original_session)
  end
end
