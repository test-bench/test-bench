require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Exclude File Pattern" do
      pattern_text = 'some-pattern'

      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-x', pattern_text])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_EXCLUDE_FILE_PATTERN']

        comment env_text.inspect

        test do
          assert(env_text == pattern_text)
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--exclude', pattern_text])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_EXCLUDE_FILE_PATTERN']

        comment env_text.inspect

        test do
          assert(env_text == pattern_text)
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-exclude'])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_EXCLUDE_FILE_PATTERN']

        comment env_text.inspect

        test "Empty" do
          assert(env_text.empty?)
        end
      end
    end
  end
end
