module TestBench
  def self.session
    Session::Store.fetch
  end

  def self.telemetry
    session&.telemetry
  end

  def self.register_telemetry_sink(telemetry_sink)
    session&.register_telemetry_sink(telemetry_sink)
  end
end
