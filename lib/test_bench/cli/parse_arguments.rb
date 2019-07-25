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

          parser.on('-a', '--[no-]abort-on-error', %{Exit immediately after any test failure or error (Default: #{TestBench::Run::Defaults.abort_on_error})}) do |abort_on_error|
            policy = TestBench::Run.error_policy(abort_on_error)

            TestBench::Fixture::ErrorPolicy.configure(test_run, policy: policy)
          end

          parser.on('-x', '--[no-]exclude PATTERN', %{Do not execute test files matching PATTERN (Default: #{Run::Defaults.exclude_file_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern = self.none_pattern
            else
              pattern = self.pattern(pattern_text)
            end

            run.exclude_file_pattern = pattern
          end

          parser.on('-o', '--[no-]omit-backtrace PATTERN', %{Omit backtrace frames matching PATTERN (Default: #{Output::Defaults.omit_backtrace_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern = self.none_pattern
            else
              pattern = self.pattern(pattern_text)
            end

            output.omit_backtrace_pattern = pattern
          end

          parser.separator(<<~TEXT)

          Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).
          If no paths are given, a default path (#{Run::Defaults.tests_directory}) is scanned for test files.

          The following environment variables can also control execution:

          #{parser.summary_indent}TEST_BENCH_ABORT_ON_ERROR          Same as -a or --abort-on-error
          #{parser.summary_indent}TEST_BENCH_EXCLUDE_FILE_PATTERN    Same as -x or --exclude-file-pattern
          #{parser.summary_indent}TEST_BENCH_OMIT_BACKTRACE_PATTERN  Same as -o or --omit-backtrace-pattern

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
