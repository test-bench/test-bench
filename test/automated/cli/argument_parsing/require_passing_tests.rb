require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Require Passing Tests" do
      context "Short Form" do
        cli = CLI.new('-p')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_REQUIRE_PASSING_TESTS']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Short Form, Negated" do
        cli = CLI.new('-P')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_REQUIRE_PASSING_TESTS']

        comment env_text.inspect

        test do
          assert(env_text == 'off')
        end
      end

      context "Long Form" do
        cli = CLI.new('--require-passing-tests')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_REQUIRE_PASSING_TESTS']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form, Negated" do
        cli = CLI.new('--no-require-passing-tests')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_REQUIRE_PASSING_TESTS']

        comment env_text.inspect

        test do
          assert(env_text == 'off')
        end
      end
    end
  end
end
