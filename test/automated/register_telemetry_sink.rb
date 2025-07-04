require_relative 'automated_init'

context "Register Telemetry Sink" do
  telemetry_sink = Controls::TelemetrySink.example

  original_session = TestBench::Session.instance

  session = TestBench::Session.new
  TestBench::Session.establish(session)

  TestBench.register_telemetry_sink(telemetry_sink)

  telemetry = session.telemetry

  test "Registered" do
    assert(telemetry.registered?(telemetry_sink))
  end

ensure
  if not original_session.nil?
    TestBench::Session.establish(original_session)
  end
end
