require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Output Styling" do
      context "Short Form" do
        parse_arguments = CLI::ParseArguments.new(['-s', 'on'])

        parse_arguments.()

        test do
          assert(parse_arguments.writer.styling?)
        end
      end

      context "Long Form" do
        parse_arguments = CLI::ParseArguments.new(['--output-styling'])

        parse_arguments.()

        test do
          assert(parse_arguments.writer.styling?)
        end
      end

      context "Optional Value" do
        context do
          parse_arguments = CLI::ParseArguments.new(['--output-styling', 'off'])

          parse_arguments.()

          test do
            refute(parse_arguments.writer.styling?)
          end
        end

        context "Invalid Text" do
          parse_arguments = CLI::ParseArguments.new(['--output-styling', 'invalid'])

          test "Raises an error" do
            assert_raises(CLI::ParseArguments::Error) do
              parse_arguments.()
            end
          end
        end
      end
    end
  end
end
