module TestBench
  def self.exit_code(session, fail_deactivated_tests: nil)
    if fail_deactivated_tests.nil?
      fail_deactivated_tests = Defaults.fail_deactivated_tests
    end

    if session.failed?
      1
    elsif session.skip?
      fail_deactivated_tests ? 2 : 0
    else
      0
    end
  end

  module Defaults
    def self.fail_deactivated_tests
      Environment::Boolean.fetch('TEST_BENCH_FAIL_DEACTIVATED_TESTS', true)
    end
  end
end
