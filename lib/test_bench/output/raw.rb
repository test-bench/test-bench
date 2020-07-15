module TestBench
  module Output
    class Raw
      def verbose
        instance_variable_defined?(:@verbose) ?
          @verbose :
          @verbose = Defaults.verbose
      end
      attr_writer :verbose
      alias_method :verbose?, :verbose

      module Defaults
        def self.verbose
          Environment::Boolean.fetch('TEST_BENCH_VERBOSE', false)
        end
      end
    end
  end
end
