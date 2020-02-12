require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Reverse Backtraces" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-r'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_REVERSE_BACKTRACES'] == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--reverse-backtraces'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_REVERSE_BACKTRACES'] == 'on')
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-reverse-backtraces'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_REVERSE_BACKTRACES'] == 'off')
        end
      end
    end
  end
end
