require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Unknown Switch" do
      cli = CLI.new('--some-unknown-switch')

      test "Is an error" do
        assert_raises(CLI::ArgumentError) do
          cli.parse_arguments
        end
      end
    end
  end
end
