require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Verbose" do
      context "Short Form" do
        parse_arguments = CLI::ParseArguments.new(['-v'])

        parse_arguments.()

        test do
          assert(parse_arguments.output.verbose == true)
        end
      end

      context "Long Form" do
        parse_arguments = CLI::ParseArguments.new(['--verbose'])

        parse_arguments.()

        test do
          assert(parse_arguments.output.verbose == true)
        end
      end

      context "Long Form, Negated" do
        parse_arguments = CLI::ParseArguments.new(['--no-verbose'])

        parse_arguments.()

        test do
          assert(parse_arguments.output.verbose == false)
        end
      end
    end
  end
end
