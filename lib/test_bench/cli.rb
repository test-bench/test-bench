module TestBench
  class CLI
    ArgumentError = Class.new(RuntimeError)

    attr_reader :arguments

    attr_accessor :exit_code

    def env
      @env ||= {}
    end
    attr_writer :env

    def program_name
      @program_name ||= Defaults.program_name
    end
    attr_writer :program_name

    def version
      @version ||= Defaults.version
    end
    attr_writer :version

    def writer
      @writer ||= Output::Writer::Substitute.build
    end
    attr_writer :writer

    def initialize(*arguments)
      @arguments = arguments
    end

    def parse_arguments
      argument_index = 0

      until argument_index == arguments.count
        next_argument = next_argument(argument_index)

        if not next_argument.start_with?('-')
          argument_index += 1
          next
        end

        switch = next_argument!(argument_index)

        case switch
        when '--'
          break

        when '-h', '--help'
          print_help_text

          self.exit_code = 0

        when '-v', '--version'
          writer.puts "TestBench Version: #{version}"

          self.exit_code = 0

        when '-d', '--detail', '--no-detail'
          if not negated?(switch)
            detail_policy_text = 'on'
          else
            detail_policy_text = 'off'
          end

          detail_policy = detail_policy_text.to_sym
          Session::Output::Detail.assure_detail(detail_policy)

          env['TEST_BENCH_DETAIL'] = detail_policy_text

        when '-x', '--exclude', '--no-exclude'
          if not negated?(switch)
            exclude_pattern_text = switch_value!(argument_index, switch)

            if env.key?('TEST_BENCH_EXCLUDE_FILE_PATTERN')
              exclude_pattern_text = [
                env['TEST_BENCH_EXCLUDE_FILE_PATTERN'],
                exclude_pattern_text
              ].join(':')
            end
          else
            exclude_pattern_text = ''
          end

          env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] = exclude_pattern_text

        when '-f', '-F', '--only-failure', '--no-only-failure'
          if not negated?(switch)
            only_failure_text = 'on'
          else
            only_failure_text = 'off'
          end

          env['TEST_BENCH_ONLY_FAILURE'] = only_failure_text

        when '-p', '-P', '--require-passing-tests', '--no-require-passing-tests'
          if not negated?(switch)
            require_passing_tests = 'on'
          else
            require_passing_tests = 'off'
          end

          env['TEST_BENCH_REQUIRE_PASSING_TESTS'] = require_passing_tests

        when '-o', '--output-styling'
          output_styling_text = switch_value(argument_index) do
            'on'
          end

          output_styling = output_styling_text.to_sym
          Output::Writer::Styling.assure_styling(output_styling)

          env['TEST_BENCH_OUTPUT_STYLING'] = output_styling_text

        when '-s', '--seed'
          seed_text = switch_value!(argument_index, switch)

          begin
            Integer(seed_text)
          rescue
            raise ArgumentError, "Seed switch must be an integer (Seed: #{seed_text.inspect})"
          end

          env['TEST_BENCH_SEED'] = seed_text

        when '-r', '--require'
          library = switch_value!(argument_index, switch)

          require library

        else
          raise ArgumentError, "Unknown switch #{switch.inspect}"
        end
      end
    end

    def print_help_text
      writer.write <<~TEXT
      Usage: #{program_name} [options] [paths]

      Informational Options:
      \t-h, --help                        Print this help message and exit successfully
      \t-v, --version                     Print version and exit successfully

      Configuration Options:
      \t-d, --[no]detail                  Always show (or hide) details (Default: #{Session::Output::Detail.default})
      \t-x, --[no-]exclude PATTERN        Do not execute test files matching PATTERN (Default: #{Run::GetFiles::Defaults.exclude_patterns.inspect})
      \t-f, --[no-]only-failure           Don't display output for test files that pass (Default: #{Run::Output::File::Defaults.only_failure ? 'on' : 'off'})
      \t-o, --output-styling [on|off|detect]
      \t                                  Render output coloring and font styling escape codes (Default: #{Output::Writer::Styling.default})
      \t-s, --seed NUMBER                 Sets pseudo-random number seed (Default: not set)

      Other Options:
      \t-r, --require LIBRARY             Require LIBRARY before running any files

      Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).

      If no paths are given, a default path (#{Defaults.tests_directory}) is scanned for test files.

      The following environment variables can also control execution:

      \tTEST_BENCH_DETAIL                 Same as -d or --detail
      \tTEST_BENCH_EXCLUDE_FILE_PATTERN   Same as -x or --exclude-file-pattern
      \tTEST_BENCH_ONLY_FAILURE           Same as -f or --only-failure
      \tTEST_BENCH_OUTPUT_STYLING         Same as -o or --output-styling
      \tTEST_BENCH_SEED                   Same as -s or --seed

      TEXT
    end

    def negated?(switch)
      if switch.start_with?('--')
        switch.start_with?('--no-')
      else
        /^-[A-Z]/.match?(switch)
      end
    end

    def exit_code?
      !exit_code.nil?
    end

    def switch_value!(argument_index, argument)
      switch_value(argument_index) do
        raise ArgumentError, "Argument #{argument.inspect} requires an argument"
      end
    end

    def switch_value(argument_index, &no_value_action)
      next_value = next_argument(argument_index)

      if next_value.nil? || next_value.start_with?('-')
        switch_value = nil

        return no_value_action.()
      else
        switch_value = next_argument!(argument_index)

        return switch_value
      end
    end

    def next_argument(argument_index)
      arguments[argument_index]
    end

    def next_argument!(argument_index)
      arguments.delete_at(argument_index)
    end

    def self.exit_code(result)
      if result == true
        0
      elsif result == false
        1
      else
        2
      end
    end

    module Defaults
      def self.tests_directory
        ENV.fetch('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
      end

      def self.program_name
        $PROGRAM_NAME || 'bench'
      end

      def self.version
        if Object.const_defined?(:Gem)
          spec = Gem.loaded_specs['test_bench']
        end

        spec&.version || '(unknown)'
      end
    end
  end
end
