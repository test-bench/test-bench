module TestBench
  def self.session
    Session::Store.fetch
  end

  def self.telemetry
    session&.telemetry
  end

  def self.register_telemetry_sink(telemetry_sink)
    telemetry.register(telemetry_sink)
  end
end
