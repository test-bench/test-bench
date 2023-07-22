require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Output Styling" do
      context "Short Form" do
        cli = CLI.new('-o')
        cli.parse_arguments

          env_text = cli.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form" do
        cli = CLI.new('--output-styling')
        cli.parse_arguments

          env_text = cli.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Optional Value" do
        context do
          cli = CLI.new('--output-styling', 'off')
          cli.parse_arguments

          env_text = cli.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

          test do
            assert(env_text == 'off')
          end
        end

        context "Invalid Text" do
          cli = CLI.new('--output-styling', 'invalid')

          test "Raises an error" do
            assert_raises(Output::Writer::Styling::Error) do
              cli.parse_arguments
            end
          end
        end
      end

      context "No Optional Value" do
        context "Final Argument" do
          cli = CLI.new('--output-styling')
          cli.parse_arguments

          env_text = cli.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

          test do
            assert(env_text == 'on')
          end
        end

        context "Next Argument Is An Option" do
          cli = CLI.new('--output-styling', '--version')
          cli.parse_arguments

          env_text = cli.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

          test do
            assert(env_text == 'on')
          end
        end
      end
    end
  end
end
