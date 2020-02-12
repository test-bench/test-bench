module TestBench
  module CLI
    class ParseArguments
      attr_reader :argv

      def output_device
        @output_device ||= StringIO.new
      end
      attr_writer :output_device

      def initialize(argv)
        @argv = argv
      end

      def call
        option_parser.parse(argv)
      end

      def option_parser
        @option_parser ||= OptionParser.new do |parser|
          parser.banner = "Usage: #{self.class.program_name} [options] [paths]"

          parser.separator('')
          parser.separator("Informational Options")

          parser.on('-h', '--help', "Print this help message and exit successfully") do
            output_device.puts(parser.help)

            exit(true)
          end
        end
      end

      def self.program_name
        $PROGRAM_NAME
      end

      module Defaults
        def self.tests_directory
          ENV.fetch('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
        end
      end
    end
  end
end
