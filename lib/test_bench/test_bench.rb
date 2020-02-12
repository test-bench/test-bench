module TestBench
  def self.session
    @session ||= build_session.tap do |session|
      at_exit do
        exit 1 if session.failed?
      end
    end
  end
  singleton_class.attr_writer(:session)

  def self.fixture(session=nil, receiver: nil)
    session ||= self.session
    receiver ||= Object.new

    receiver.extend(Fixture)
    receiver.extend(UnderscoreVariants)

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
