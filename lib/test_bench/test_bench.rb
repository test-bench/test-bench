module TestBench
  def self.activate(receiver=nil)
    receiver ||= TOPLEVEL_BINDING.receiver

    receiver.extend(Fixture)
    receiver.extend(DeactivatedVariants)
    receiver.extend(TestSession)

    session = receiver.test_session
    establish_output(session)
  end

  def self.context(title=nil, session: nil, &block)
    evaluate(session:) do
      context(title) do
        instance_exec(&block)
      end
    end
  end

  def self.evaluate(session: nil, &block)
    session ||= Session.build

    original_session = Session.instance

    Session.establish(session)

    establish_output(session)

    fixture = TestBench::Fixture::Evaluate.build(test_session: session, &block)
    fixture.extend(DeactivatedVariants)
    fixture.()

    result = fixture.test_session.result
    Session::Result.resolve(result)

  ensure
    Session.establish(original_session)
  end

  def self.register_telemetry_sink(telemetry_sink)
    Session.register_telemetry_sink(telemetry_sink)
  end

  def self.establish_output(session)
    if session.telemetry.sinks.none?
      Output.register_telemetry_sink(session)
    end
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
    def test_session
      Session.instance
    end

    def test_session=(session)
      Session.establish(session)
    end
  end
end
