module TestBench
  module DeactivationVariants
    def _context(title=nil, &block)
      test_session.fail! if Defaults.fail_session

      context(title)
    end

    def _test(title=nil, &block)
      test_session.fail! if Defaults.fail_session

      test(title)
    end

    module Defaults
      def self.fail_session
        Environment::Boolean.fetch('TEST_BENCH_FAIL_DEACTIVATED_TESTS', true)
      end
    end
  end
end
