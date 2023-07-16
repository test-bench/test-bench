require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Detail" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-d'])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_DETAIL']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--detail'])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_DETAIL']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-detail'])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_DETAIL']

        comment env_text.inspect

        test do
          assert(env_text == 'off')
        end
      end
    end
  end
end

