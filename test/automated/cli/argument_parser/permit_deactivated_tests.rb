require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Permit Deactivated Tests" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-p'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_FAIL_DEACTIVATED_TESTS'] == 'off')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--permit-deactivated-tests'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_FAIL_DEACTIVATED_TESTS'] == 'off')
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-permit-deactivated-tests'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_FAIL_DEACTIVATED_TESTS'] == 'on')
        end
      end
    end
  end
end
