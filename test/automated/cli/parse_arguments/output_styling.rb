require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Output Styling" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-o'])
        argument_parser.()

          env_text = argument_parser.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--output-styling'])
        argument_parser.()

          env_text = argument_parser.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

        test do
          assert(env_text == 'on')
        end
      end

      context "Optional Value" do
        context do
          argument_parser = CLI::ParseArguments.new(['--output-styling', 'off'])
          argument_parser.()

          env_text = argument_parser.env['TEST_BENCH_OUTPUT_STYLING']

          comment env_text.inspect

          test do
            assert(env_text == 'off')
          end
        end

        context "Invalid Text" do
          argument_parser = CLI::ParseArguments.new(['--output-styling', 'invalid'])

          test "Raises an error" do
            assert_raises(Output::Writer::Styling::Error) do
              argument_parser.()
            end
          end
        end
      end
    end
  end
end
