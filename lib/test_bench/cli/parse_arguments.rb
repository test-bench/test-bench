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

          parser.on('-x', '--[no-]exclude PATTERN', %{Do not execute test files matching PATTERN (Default: #{Run::Defaults.exclude_file_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern_text = self.none_pattern
            end

            assure_pattern(pattern_text)

            env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] = pattern_text
          end

          parser.on('-o', '--[no-]omit-backtrace PATTERN', %{Omit backtrace frames matching PATTERN (Default: #{Output::PrintError::Defaults.omit_backtrace_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern_text = self.none_pattern
            end

            assure_pattern(pattern_text)

            env['TEST_BENCH_OMIT_BACKTRACE_PATTERN'] = pattern_text
          end

          parser.on('-l', '--output-level [none|summary|failure|pass|debug]', %{Sets output level (Default: #{Output::Build::Defaults.level})}) do |level_text|
            level = level_text.to_sym

            Output::Build.assure_level(level)

            env['TEST_BENCH_OUTPUT_LEVEL'] = level_text
          end

          parser.on('-s', '--output-styling [on|off|detect]', %{Render output coloring and font styling escape codes (Default: #{Output::Writer::Defaults.styling_setting})}) do |styling_text|
            styling_text ||= 'on'

            styling_setting = styling_text.to_sym

            Output::Writer.assure_styling_setting(styling_setting)

            env['TEST_BENCH_OUTPUT_STYLING'] = styling_text
          end

          parser.on('-r', '--[no-]reverse-backtraces', %{Reverse order of backtraces when printing errors (Default: #{Output::PrintError::Defaults.reverse_backtraces ? 'on' : 'off'})}) do |reverse_backtraces|
            env['TEST_BENCH_REVERSE_BACKTRACES'] = reverse_backtraces ? 'on' : 'off'
          end

          parser.separator(<<~TEXT)

          Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).
          If no paths are given, a default path (#{Defaults.tests_directory}) is scanned for test files.

          The following environment variables can also control execution:

          #{parser.summary_indent}TEST_BENCH_ABORT_ON_ERROR          Same as -a or --abort-on-error
          #{parser.summary_indent}TEST_BENCH_EXCLUDE_FILE_PATTERN    Same as -x or --exclude-file-pattern
          #{parser.summary_indent}TEST_BENCH_OMIT_BACKTRACE_PATTERN  Same as -o or --omit-backtrace-pattern
          #{parser.summary_indent}TEST_BENCH_OUTPUT_LEVEL            Same as -l or --output-level
          #{parser.summary_indent}TEST_BENCH_OUTPUT_STYLING          Same as -s or --output-styling
          #{parser.summary_indent}TEST_BENCH_REVERSE_BACKTRACES      Same as -r or --reverse-backtraces

          TEXT

          parser.separator(<<~TEXT)
          Finally, the VERBOSE environment variable can set the output level to debug. If given, VERBOSE will take precedence over TEST_BENCH_OUTPUT_STYLING.

          TEXT
        end
      end

      def assure_pattern(pattern_text)
        Regexp.new(pattern_text)
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
