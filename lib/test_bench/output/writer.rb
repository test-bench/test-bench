module TestBench
  class Output
    class Writer
      Error = Class.new(RuntimeError)

      def device
        @device ||= StringIO.new
      end
      attr_writer :device

      def styling
        @styling ||= false
      end
      attr_writer :styling
      alias_method :styling?, :styling

      def configure(device: nil, styling: nil)
        device ||= Defaults.device

        self.device = device
        self.styling = self.class.styling?(device, styling)
      end

      def self.build(device=nil, styling: nil)
        instance = new
        instance.configure(device: device, styling: styling)
        instance
      end

      def self.styling?(device, styling_setting=nil)
        styling_setting ||= Defaults.styling_setting

        styling_setting = styling_setting.to_sym

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
          ::ENV.fetch('TEST_BENCH_OUTPUT_STYLING') do
            Writer.default_styling_setting
          end
        end
      end
    end
  end
end
