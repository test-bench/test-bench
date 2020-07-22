module TestBench
  module CLI
    class ParseArguments
      attr_reader :argv

      def env
        @env ||= {}
      end
      attr_writer :env

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

          parser.on('-V', '--version', "Print version and exit successfully") do
            output_device.puts <<~TEXT
            test-bench (#{self.class.program_name}) version #{self.class.version}
            TEXT

            exit(true)
          end

          parser.separator('')
          parser.separator("Configuration Options")

          parser.on('-a', '--[no-]abort-on-error', %{Exit immediately after any test failure or error (Default: #{Session::Defaults.abort_on_error ? 'on' : 'off'})}) do |abort_on_error|
            env['TEST_BENCH_ABORT_ON_ERROR'] = abort_on_error ? 'on' : 'off'
          end

          parser.on('-d', '--[no-]detail [DETAIL]', %{Always show (or hide) details (Default: #{Output::Raw::Defaults.detail})}) do |detail|
            if detail.nil?
              detail = 'on'
            elsif detail == true
              detail = 'on'
            elsif detail == false
              detail = 'off'
            end

            env['TEST_BENCH_DETAIL'] = detail
          end

          parser.separator(<<~TEXT)

          Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).
          If no paths are given, a default path (#{Defaults.tests_directory}) is scanned for test files.

          The following environment variables can also control execution:

          #{parser.summary_indent}TEST_BENCH_ABORT_ON_ERROR          Same as -a or --abort-on-error
          #{parser.summary_indent}TEST_BENCH_DETAIL                  Same as -d or --detail

          TEXT
        end
      end

      def self.program_name
        $PROGRAM_NAME
      end

      def self.version
        if defined?(Gem)
          spec = Gem.loaded_specs['test_bench']
        end

        spec&.version || '(unknown)'
      end

      module Defaults
        def self.tests_directory
          ENV.fetch('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
        end
      end
    end
  end
end
