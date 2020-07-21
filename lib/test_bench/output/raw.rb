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

      attr_accessor :current_batch

      def batch_starting(batch_data)
        if batch_data.depth.zero?
          self.current_batch = batch_data
        end
      end

      def batch_finished(batch_data)
        if batch_data.depth.zero?
          self.current_batch = nil
        end
      end

      module Defaults
        def self.verbose
          Environment::Boolean.fetch('TEST_BENCH_VERBOSE', false)
        end
      end
    end
  end
end
