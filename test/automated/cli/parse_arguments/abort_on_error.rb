require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Abort On Error" do
      context "Short Form" do
        parse_arguments = CLI::ParseArguments.new(['-a'])

        parse_arguments.()

        test do
          assert(parse_arguments.test_run.error_policy.instance_of?(TestBench::Fixture::ErrorPolicy::Abort))
        end
      end

      context "Long Form" do
        parse_arguments = CLI::ParseArguments.new(['--abort-on-error'])

        parse_arguments.()

        test do
          assert(parse_arguments.test_run.error_policy.instance_of?(TestBench::Fixture::ErrorPolicy::Abort))
        end
      end

      context "Long Form, Negated" do
        parse_arguments = CLI::ParseArguments.new(['--no-abort-on-error'])

        parse_arguments.()

        test do
          assert(parse_arguments.test_run.error_policy.instance_of?(TestBench::Fixture::ErrorPolicy::Rescue))
        end
      end
    end
  end
end
