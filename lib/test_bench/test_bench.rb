module TestBench
  def self.session
    Session::Store.fetch
  end

  def self.telemetry
    session&.telemetry
  end
end
