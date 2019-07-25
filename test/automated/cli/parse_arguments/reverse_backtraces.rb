require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Reverse Backtraces" do
      context "Short Form" do
        parse_arguments = CLI::ParseArguments.new(['-r'])

        parse_arguments.()

        test do
          assert(parse_arguments.output.reverse_backtraces == true)
        end
      end

      context "Long Form" do
        parse_arguments = CLI::ParseArguments.new(['--reverse-backtraces'])

        parse_arguments.()

        test do
          assert(parse_arguments.output.reverse_backtraces == true)
        end
      end

      context "Long Form, Negated" do
        parse_arguments = CLI::ParseArguments.new(['--no-reverse-backtraces', 'on'])

        parse_arguments.()

        test do
          assert(parse_arguments.output.reverse_backtraces == false)
        end
      end
    end
  end
end
