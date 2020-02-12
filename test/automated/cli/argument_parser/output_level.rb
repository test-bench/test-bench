require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Output Level" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-l', 'debug'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_OUTPUT_LEVEL'] == 'debug')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--output-level', 'debug'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_OUTPUT_LEVEL'] == 'debug')
        end
      end

      context "Invalid Text" do
        argument_parser = CLI::ParseArguments.new(['--output-level', 'invalid'])

        test "Is an error" do
          assert_raises(Output::Build::Error) do
            argument_parser.()
          end
        end
      end
    end
  end
end
