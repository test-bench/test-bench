module TestBench
  class CLI
    class ParseArguments
      Error = Class.new(RuntimeError)

      attr_reader :argv

      def run
        @run ||= Run.build(test_run: TestBench::Run.build)
      end
      attr_writer :run

      def test_run
        run.test_run
      end

      def output
        test_run.output
      end

      def writer
        output.writer
      end

      def output_device
        @output_device ||= writer.device
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

          parser.on('-a', '--[no-]abort-on-error', %{Exit immediately after any test failure or error (Default: #{test_run.abort_on_error?})}) do |abort_on_error|
            policy = TestBench::Run.error_policy(abort_on_error)

            TestBench::Fixture::ErrorPolicy.configure(test_run, policy: policy)
          end

          parser.on('-x', '--[no-]exclude PATTERN', %{Do not execute test files matching PATTERN (Default: #{run.exclude_file_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern = self.none_pattern
            else
              pattern = self.pattern(pattern_text)
            end

            run.exclude_file_pattern = pattern
          end

          parser.on('-o', '--[no-]omit-backtrace PATTERN', %{Omit backtrace frames matching PATTERN (Default: #{output.omit_backtrace_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern = self.none_pattern
            else
              pattern = self.pattern(pattern_text)
            end

            output.omit_backtrace_pattern = pattern
          end

          parser.on('-s', '--output-styling [on|off|detect]', %{Render output coloring and font styling escape codes (Default: #{writer.styling})}) do |styling_text|
            styling_text ||= 'on'

            styling = styling_text.to_sym

            Output::Writer.configure(output, styling: styling)
          end

          parser.on('-r', '--[no-]reverse-backtraces', %{Reverse order of backtraces when printing errors (Default: #{output.reverse_backtraces})}) do |reverse_backtraces|
            output.reverse_backtraces = reverse_backtraces
          end

          parser.on('-d', '--tests-directory DIR', %{Directory to scan for test files when none are specified (Default: #{run.tests_directory.inspect})}) do |path|
            unless File.directory?(path)
              raise Error, "Path is not a directory (Path: #{path.inspect})"
            end

            run.tests_directory = path
          end

          parser.separator(<<~TEXT)

          Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).
          If no paths are given, a default path (#{run.tests_directory}) is scanned for test files.

          The following environment variables can also control execution:

          #{parser.summary_indent}TEST_BENCH_ABORT_ON_ERROR          Same as -a or --abort-on-error
          #{parser.summary_indent}TEST_BENCH_EXCLUDE_FILE_PATTERN    Same as -x or --exclude-file-pattern
          #{parser.summary_indent}TEST_BENCH_OMIT_BACKTRACE_PATTERN  Same as -o or --omit-backtrace-pattern
          #{parser.summary_indent}TEST_BENCH_OUTPUT_STYLING          Same as -s or --output-styling
          #{parser.summary_indent}TEST_BENCH_REVERSE_BACKTRACES      Same as -r or --reverse-backtraces
          #{parser.summary_indent}TEST_BENCH_TESTS_DIRECTORY         Same as -d or --tests-directory

          TEXT
        end
      end

      def pattern(pattern_text)
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
    end
  end
end
