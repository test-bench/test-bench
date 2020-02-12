module TestBench
  def self.session
    @session ||= build_session.tap do |session|
      at_exit do
        exit_code = exit_code(session)

        exit(exit_code) unless exit_code.zero?
      end
    end
  end
  singleton_class.attr_writer(:session)

  def self.build_session(output: nil, abort_on_error: nil, **args)
    output ||= Output.build
    error_policy = session_error_policy(abort_on_error)

    Fixture::Session.build(output: output, error_policy: error_policy, **args)
  end

  def self.session_error_policy(abort_on_error=nil)
    abort_on_error = Defaults.abort_on_error if abort_on_error.nil?

    if abort_on_error
      :abort
    else
      :rescue
    end
  end

  def self.exit_code(session, fail_deactivated_tests: nil)
    if fail_deactivated_tests.nil?
      fail_deactivated_tests = Defaults.fail_deactivated_tests
    end

    if session.failed?
      1
    elsif session.skipped?
      fail_deactivated_tests ? 2 : 0
    else
      0
    end
  end

  Session = Fixture::Session

  module Defaults
    def self.abort_on_error
      Environment::Boolean.fetch('TEST_BENCH_ABORT_ON_ERROR', false)
    end

    def self.fail_deactivated_tests
      Environment::Boolean.fetch('TEST_BENCH_FAIL_DEACTIVATED_TESTS', true)
    end
  end
end
