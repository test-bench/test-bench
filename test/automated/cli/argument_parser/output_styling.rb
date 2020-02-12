require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Output Styling" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-s'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_OUTPUT_STYLING'] == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--output-styling'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_OUTPUT_STYLING'] == 'on')
        end
      end

      context "Optional Value" do
        context do
          argument_parser = CLI::ParseArguments.new(['--output-styling', 'off'])

          argument_parser.()

          test do
            assert(argument_parser.env['TEST_BENCH_OUTPUT_STYLING'] == 'off')
          end
        end

        context "Invalid Text" do
          argument_parser = CLI::ParseArguments.new(['--output-styling', 'invalid'])

          test "Raises an error" do
            assert_raises(Output::Writer::Error) do
              argument_parser.()
            end
          end
        end
      end
    end
  end
end
