module TestBench
  module Output
    class Writer
      Error = Class.new(RuntimeError)

      def device
        @device ||= StringIO.new
      end
      attr_writer :device

      attr_accessor :styling

      def styling_enabled
        instance_variable_defined?(:@styling_enabled) ?
          @styling_enabled :
          @styling_enabled = self.class.styling?(device, styling)
      end
      attr_writer :styling_enabled
      alias_method :styling?, :styling_enabled

      def mode
        @mode ||= Mode.text
      end
      attr_writer :mode

      def byte_offset
        @byte_offset ||= 0
      end
      attr_writer :byte_offset

      def indentation_depth
        @indentation_depth ||= 0
      end
      attr_writer :indentation_depth

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

      def text(text)
        if mode == Mode.escape_sequence
          self.mode = Mode.text

          write('m')
        end

        write(text)

        self
      end

      def escape_code(id)
        escape_code = SGR.escape_code(id)

        if mode == Mode.text
          return self unless styling?

          self.mode = Mode.escape_sequence

          write("\e[")
        else
          write(';')
        end

        write(escape_code)

        self
      end

      def sync
        text('')
      end

      def indent
        indentation = '  ' * indentation_depth

        text(indentation)
      end

      def newline
        sync
        device.puts
        self.byte_offset += 1
        self
      end

      def write(data)
        bytes_written = device.write(data)

        self.byte_offset += bytes_written
      end

      def current?(byte_offset)
        byte_offset >= self.byte_offset
      end

      def increase_indentation
        self.indentation_depth += 1
      end

      def decrease_indentation
        self.indentation_depth -= 1
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

      module Mode
        def self.text
          :text
        end

        def self.escape_sequence
          :escape_sequence
        end
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
