module TestBench
  module Output
    class Raw
      Error = Class.new(RuntimeError)

      def verbose
        instance_variable_defined?(:@verbose) ?
          @verbose :
          @verbose = Defaults.verbose
      end
      attr_writer :verbose
      alias_method :verbose?, :verbose

      def detail_setting
        @detail_setting ||= Defaults.detail
      end
      attr_writer :detail_setting

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

      def detail?(result=nil)
        result ||= current_batch&.result

        case detail_setting
        when :failure
          result != true
        when :on
          true
        when :off
          false
        end
      end

      def self.assure_detail_setting(detail_setting)
        unless detail_settings.include?(detail_setting)
          raise Error, "Invalid detail setting #{detail_setting.inspect} (Valid values: #{detail_settings.map(&:inspect).join(', ')})"
        end
      end

      def self.detail_settings
        [
          :failure,
          :on,
          :off
        ]
      end

      def self.default_detail_setting
        detail_settings.fetch(0)
      end

      module Defaults
        def self.verbose
          Environment::Boolean.fetch('TEST_BENCH_VERBOSE', false)
        end

        def self.detail
          detail = ::ENV['TEST_BENCH_DETAIL']

          if detail.nil?
            Raw.default_detail_setting
          else
            detail.to_sym
          end
        end
      end
    end
  end
end
