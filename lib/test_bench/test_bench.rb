module TestBench
  def self.activate(receiver=nil, session_store: nil)
    receiver ||= TOPLEVEL_BINDING.receiver
    session_store ||= Session::Store.instance

    receiver.extend(Fixture)
    receiver.extend(DeactivatedVariants)

    receiver.extend(TestSession)
    receiver.test_session_store = session_store
  end

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

  module TestSession
    attr_accessor :test_session_store

    def test_session
      test_session_store.fetch
    end
  end
end
