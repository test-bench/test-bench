require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Only Failure" do
      context "Short Form" do
        cli = CLI.new('-f')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_ONLY_FAILURE']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Short Form, Negated" do
        cli = CLI.new('-F')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_ONLY_FAILURE']

        comment env_text.inspect

        test do
          assert(env_text == 'off')
        end
      end

      context "Long Form" do
        cli = CLI.new('--only-failure')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_ONLY_FAILURE']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form, Negated" do
        cli = CLI.new('--no-only-failure')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_ONLY_FAILURE']

        comment env_text.inspect

        test do
          assert(env_text == 'off')
        end
      end
    end
  end
end
