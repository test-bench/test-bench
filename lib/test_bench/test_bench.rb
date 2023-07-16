module TestBench
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

  module DeactivatedVariants
    def _context(title=nil, &)
      context(title)
    end

    def _test(title=nil, &)
      test(title)
    end
  end
end
