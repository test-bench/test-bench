require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Exclude File Pattern" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-f'])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_ONLY_FAILURE']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--only-failure'])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_ONLY_FAILURE']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-only-failure'])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_ONLY_FAILURE']

        comment env_text.inspect

        test "Empty" do
          assert(env_text == 'off')
        end
      end
    end
  end
end
