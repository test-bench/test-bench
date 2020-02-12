require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Abort On Error" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-a'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_ABORT_ON_ERROR'] == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--abort-on-error'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_ABORT_ON_ERROR'] == 'on')
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-abort-on-error'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_ABORT_ON_ERROR'] == 'off')
        end
      end
    end
  end
end
