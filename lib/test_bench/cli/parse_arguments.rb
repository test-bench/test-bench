module TestBench
  module CLI
    class ParseArguments
      Error = Class.new(RuntimeError)

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

            raise SystemExit.new(0)
          end

          parser.on('-V', '--version', "Print version and exit successfully") do
            output_device.puts <<TEXT
test-bench (#{self.class.program_name}) version #{self.class.version}
TEXT

            raise SystemExit.new(0)
          end

          parser.separator('')
          parser.separator("Configuration Options")

          parser.on('-a', '--[no-]abort-on-error', %{Exit immediately after any test failure or error (Default: #{TestBench::Defaults.abort_on_error ? 'on' : 'off'})}) do |abort_on_error|
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

          parser.on('-x', '--[no-]exclude PATTERN', %{Do not execute test files matching PATTERN (Default: #{Run::Defaults.exclude_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern_text = self.none_pattern
            end

            assure_pattern(pattern_text)

            env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] = pattern_text
          end

          parser.on('-l', '--log-level LEVEL', %{Set the internal logging level to LEVEL (Default: #{Output::Log::Defaults.level})}) do |level_text|
            level = level_text.to_sym

            Fixture::Output::Log.assure_level(level)

            env['TEST_BENCH_LOG_LEVEL'] = level_text
          end

          parser.on('-o', '--[no-]omit-backtrace PATTERN', %{Omit backtrace frames matching PATTERN (Default: #{Output::PrintError::Defaults.omit_backtrace_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern_text = self.none_pattern
            end

            assure_pattern(pattern_text)

            env['TEST_BENCH_OMIT_BACKTRACE_PATTERN'] = pattern_text
          end

          parser.on('-s', '--output-styling [on|off|detect]', %{Render output coloring and font styling escape codes (Default: #{Output::Writer::Defaults.styling})}) do |styling_text|
            styling_text ||= 'on'

            styling = styling_text.to_sym

            Output::Writer.assure_styling_setting(styling)

            env['TEST_BENCH_OUTPUT_STYLING'] = styling_text
          end

          parser.on('-p', '--[no-]permit-deactivated-tests', %{Do not fail the test run if there are deactivated tests or contexts, e.g. _test or _context (Default: #{!TestBench::Defaults.fail_deactivated_tests ? 'on' : 'off'})}) do |permit_deactivated_tests|
            env['TEST_BENCH_FAIL_DEACTIVATED_TESTS'] = !permit_deactivated_tests ? 'on' : 'off'
          end

          parser.separator(<<TEXT)

Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).
If no paths are given, a default path (#{Defaults.tests_directory}) is scanned for test files.

The following environment variables can also control execution:

#{parser.summary_indent}TEST_BENCH_ABORT_ON_ERROR          Same as -a or --abort-on-error
#{parser.summary_indent}TEST_BENCH_DETAIL                  Same as -d or --detail
#{parser.summary_indent}TEST_BENCH_EXCLUDE_FILE_PATTERN    Same as -x or --exclude-file-pattern
#{parser.summary_indent}TEST_BENCH_LOG_LEVEL               Same as -l or --log-level
#{parser.summary_indent}TEST_BENCH_OMIT_BACKTRACE_PATTERN  Same as -o or --omit-backtrace-pattern
#{parser.summary_indent}TEST_BENCH_OUTPUT_STYLING          Same as -s or --output-styling
#{parser.summary_indent}TEST_BENCH_FAIL_DEACTIVATED_TESTS  Opposite of -p or --permit-deactivated-tests

TEXT
        end
      end

      def assure_pattern(pattern_text)
        Regexp.new(pattern_text.to_s)
      rescue RegexpError
        raise Error, "Invalid regular expression pattern (Pattern: #{pattern_text.inspect})"
      end

      def none_pattern
        /\z./
      end

      def self.program_name
        $PROGRAM_NAME
      end

      def self.version
        if Object.const_defined?(:Gem)
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
