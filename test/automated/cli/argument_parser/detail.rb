require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Detail" do
      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-d'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_DETAIL'] == 'on')
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--detail'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_DETAIL'] == 'on')
        end
      end

      context "Long Form, Argument" do
        argument_parser = CLI::ParseArguments.new(['--detail', 'failure'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_DETAIL'] == 'failure')
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-detail'])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_DETAIL'] == 'off')
        end
      end
    end
  end
end

