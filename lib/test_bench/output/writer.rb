module TestBench
  class Output
    class Writer
      Error = Class.new(RuntimeError)

      def device
        @device ||= StringIO.new
      end
      attr_writer :device

      attr_accessor :previous_device

      def styling
        @styling ||= false
      end
      attr_writer :styling
      alias_method :styling?, :styling

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

        self.device = device
        self.styling = self.class.styling?(device, styling)
      end

      def self.build(device=nil, styling: nil)
        instance = new
        instance.configure(device: device, styling: styling)
        instance
      end

      def self.configure(receiver, device=nil, styling: nil, attr_name: nil)
        attr_name ||= :writer

        instance = build(device, styling: styling)
        receiver.public_send(:"#{attr_name}=", instance)
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

      def start_capture(str=nil)
        str ||= String.new

        unless previous_device.nil?
          raise Error, "Already capturing (Capture String: #{device.string.inspect}, Previous Device: #{previous_device.inspect})"
        end
        self.previous_device = self.device

        capture_device = StringIO.new(str)
        self.device = capture_device
      end

      def stop_capture
        if previous_device.nil?
          raise Error, "Not yet capturing (Device: #{device.inspect})"
        end

        string = device.string

        self.device = previous_device
        self.previous_device = nil

        string
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
          ::ENV.fetch('TEST_BENCH_OUTPUT_STYLING') do
            Writer.default_styling_setting
          end
        end
      end
    end
  end
end
