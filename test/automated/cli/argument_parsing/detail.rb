require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Detail" do
      context "Short Form" do
        cli = CLI.new('-d')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_DETAIL']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form" do
        cli = CLI.new('--detail')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_DETAIL']

        comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form, Negated" do
        cli = CLI.new('--no-detail')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_DETAIL']

        comment env_text.inspect

        test do
          assert(env_text == 'off')
        end
      end
    end
  end
end

