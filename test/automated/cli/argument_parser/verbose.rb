require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Verbose" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-v'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_VERBOSE'] == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--verbose'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_VERBOSE'] == 'on')
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-verbose'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_VERBOSE'] == 'off')
        end
      end
    end
  end
end
