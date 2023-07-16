require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Final Arguments" do
      switch_arguments = ['--detail', '--exclude', '*', '--only-failure', '--output-styling', '--seed', '1111']

      context "None" do
        cli = CLI.new(*switch_arguments)

        cli.parse_arguments

        test "No more arguments" do
          assert(cli.arguments.empty?)
        end

        test "No exit code" do
          refute(cli.exit_code?)
        end
      end

      context "Paths" do
        cli = CLI.new('some-path', *switch_arguments, 'some-other-path')

        cli.parse_arguments

        context "Ignored" do
          ignored = cli.arguments == ['some-path', 'some-other-path']

          comment cli.arguments.join(', ')

          test do
            assert(ignored)
          end
        end

        test "No exit code" do
          refute(cli.exit_code?)
        end
      end

      context "Ignored Switches" do
        cli = CLI.new(*switch_arguments, '--', '--some-ignored-switch', '--some-other-ignored-switch')

        cli.parse_arguments

        context "Ignored" do
          ignored = cli.arguments == ['--some-ignored-switch', '--some-other-ignored-switch']

          comment cli.arguments.join(', ')

          test do
            assert(ignored)
          end
        end

        test "No exit code" do
          refute(cli.exit_code?)
        end
      end
    end
  end
end
