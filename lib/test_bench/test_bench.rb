module TestBench
  def self.context(title=nil, session: nil, &block)
    evaluate(session:) do
      context(title) do
        instance_exec(&block)
      end
    end
  end

  def self.evaluate(session: nil, &block)
    fixture = TestBench::Fixture::Evaluate.build(session:, &block)
    fixture.extend(DeactivatedVariants)
    fixture.()

    fixture.test_session.passed?
  end

  def self.session
    Session::Store.fetch
  end

  def self.telemetry
    session&.telemetry
  end

  def self.register_telemetry_sink(telemetry_sink)
    telemetry.register(telemetry_sink)
  end

  module DeactivatedVariants
    def _context(title=nil, &)
      context(title)
    end

    def _test(title=nil, &)
      test(title)
    end
  end
end
