module TestBench
  def self.session
    @session ||= build_session.tap do |session|
      at_exit do
        exit 1 if session.failed?
      end
    end
  end
  singleton_class.attr_writer(:session)

  def self.output
    session.output
  end

  def self.set_output(output, session: nil)
    session ||= self.session

    if output.is_a?(Array)
      output = Fixture::Output::Multiple.build(*output)
    end

    session.output = output
  end
  singleton_class.alias_method :output=, :set_output

  def self.activate(receiver=nil, session: nil)
    receiver ||= TOPLEVEL_BINDING.receiver

    fixture(session, receiver: receiver)
  end

  def self.evaluate(session: nil, &block)
    fixture = fixture(session)

    fixture.test_session.evaluate(->{
      fixture.instance_exec(&block)
    })
  end

  def self.fixture(session=nil, receiver: nil)
    session ||= self.session
    receiver ||= Object.new

    receiver.extend(Fixture)
    receiver.extend(DeactivationVariants)

    receiver.test_session = session

    receiver
  end

  def self.build_session(output: nil, abort_on_error: nil, **args)
    output ||= Output.build
    error_policy = session_error_policy(abort_on_error)

    Fixture::Session.build(output: output, error_policy: error_policy, **args)
  end

  def self.session_error_policy(abort_on_error=nil)
    abort_on_error = Session::Defaults.abort_on_error if abort_on_error.nil?

    if abort_on_error
      :abort
    else
      :rescue
    end
  end

  Session = Fixture::Session

  module Session::Defaults
    def self.abort_on_error
      Environment::Boolean.fetch('TEST_BENCH_ABORT_ON_ERROR', false)
    end
  end
end
