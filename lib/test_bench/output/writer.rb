module TestBench
  class Output
    class Writer
      Error = Class.new(RuntimeError)

      def device
        @device ||= StringIO.new
      end
      attr_writer :device

      attr_accessor :styling

      def styling_enabled
        @styling_enabled ||= self.class.styling?(device, styling)
      end
      attr_writer :styling_enabled
      alias_method :styling?, :styling_enabled

      def configure(device: nil, styling: nil)
        device ||= Defaults.device

        unless styling.nil?
          self.class.assure_styling_setting(styling)
        end

        self.device = device
        self.styling = styling
      end

      def self.build(device=nil, styling: nil)
        instance = new
        instance.configure(device: device, styling: styling)
        instance
      end

      def self.styling?(device, styling_setting=nil)
        styling_setting ||= Defaults.styling_setting

        assure_styling_setting(styling_setting)

        case styling_setting
        when :detect
          device.tty?
        when :on
          true
        when :off
          false
        end
      end

      def self.assure_styling_setting(styling_setting)
        unless styling_settings.include?(styling_setting)
          raise Error, "Invalid output styling #{styling_setting.inspect} (Valid values: #{styling_settings.map(&:inspect).join(', ')})"
        end
      end

      def self.styling_settings
        [
          :detect,
          :on,
          :off
        ]
      end

      def self.default_styling_setting
        styling_settings.fetch(0)
      end

      module Defaults
        def self.device
          $stdout
        end

        def self.styling_setting
          styling = ::ENV['TEST_BENCH_OUTPUT_STYLING']

          if styling.nil?
            Writer.default_styling_setting
          else
            styling.to_sym
          end
        end
      end
    end
  end
end
