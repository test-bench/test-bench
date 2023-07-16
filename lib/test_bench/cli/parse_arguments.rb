module TestBench
  module CLI
    class ParseArguments
      Error = Class.new(RuntimeError)

      attr_reader :argv

      def env
        @env ||= {}
      end
      attr_writer :env

      def output_writer
        @output_writer ||= Output::Writer::Substitute.build
      end
      attr_writer :output_writer

      def initialize(argv)
        @argv = argv
      end

      def self.build(argv=nil, env: nil)
        argv ||= ::ARGV
        env ||= ::ENV

        instance = new(argv)
        instance.output_writer = Output::Writer::Defaults.device
        instance.env = env
        instance
      end

      def self.call(argv=nil, env: nil)
        instance = build(argv, env: env)
        instance.()
      end

      def call
        option_parser = OptionParser.new do |parser|
          parser.banner = "Usage: #{self.class.program_name} [options] [paths]"

          parser.separator('')
          parser.separator("Informational Options")

          parser.on('-h', '--help', "Print this help message and exit successfully") do
            output_writer.puts(parser.help)

            raise SystemExit.new(0)
          end

          parser.on('-V', '--version', "Print version and exit successfully") do
            output_writer.puts <<TEXT
test-bench (#{self.class.program_name}) version #{self.class.version}
TEXT

            raise SystemExit.new(0)
          end

          parser.separator('')
          parser.separator("Configuration Options")

          parser.on('-d', '--[no-]detail', %{Always show (or hide) details (Default: #{Session::Output::Detail.default})}) do |detail|
            if detail.nil?
              policy_text = 'failure'
            elsif detail == true
              policy_text = 'on'
            elsif detail == false
              policy_text = 'off'
            end

            policy = policy_text.to_sym
            Session::Output::Detail.assure_detail(policy)

            env['TEST_BENCH_DETAIL'] = policy_text
          end

          parser.on('-x', '--[no-]exclude PATTERN', %{Do not execute test files matching PATTERN (Default: #{Run::GetFiles::Defaults.exclude_file_pattern.inspect})}) do |pattern_text|
            if pattern_text == false
              pattern_text = ''
            end

            env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] = pattern_text
          end

          parser.on('-f', '--[no-]only-failure', %{Don't display output for test files that pass (Default: #{Run::Output::File::Defaults.only_failure ? 'on' : 'off'})}) do |only_failure_text|
            if only_failure_text == false
              only_failure_text = 'off'
            else
              only_failure_text = 'on'
            end

            env['TEST_BENCH_ONLY_FAILURE'] = only_failure_text
          end

          parser.on('-o', '--output-styling [on|off|detect]', %{Render output coloring and font styling escape codes (Default: #{Output::Writer::Styling.default})}) do |styling_text|
            styling_text ||= 'on'

            styling = styling_text.to_sym
            Output::Writer::Styling.assure_styling(styling)

            env['TEST_BENCH_OUTPUT_STYLING'] = styling_text
          end

          parser.on('-s', '--seed NUMBER', %{Sets pseudo-random number seed (Default: not set)}) do |seed_number_text|
            env['TEST_BENCH_SEED'] = seed_number_text
          end

          parser.separator(<<TEXT)

Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).
If no paths are given, a default path (#{Defaults.tests_directory}) is scanned for test files.

The following environment variables can also control execution:

#{parser.summary_indent}TEST_BENCH_DETAIL                  Same as -d or --detail
#{parser.summary_indent}TEST_BENCH_EXCLUDE_FILE_PATTERN    Same as -x or --exclude-file-pattern
#{parser.summary_indent}TEST_BENCH_ONLY_FAILURE            Same as -f or --only-failure
#{parser.summary_indent}TEST_BENCH_OUTPUT_STYLING          Same as -o or --output-styling
#{parser.summary_indent}TEST_BENCH_SEED                    Same as -s or --seed

TEXT
        end

        option_parser.parse(argv)
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
