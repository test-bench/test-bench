require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Require" do
      context "Short Form" do
        file = Controls::File::Create.()

        cli = CLI.new('-r', "./#{file}")
        cli.parse_arguments

        required = $LOADED_FEATURES.last.match?(file)

        test "Required" do
          assert(required)
        end
      end

      context "Long Form" do
        file = Controls::File::Create.()

        cli = CLI.new('--require', "./#{file}")
        cli.parse_arguments

        required = $LOADED_FEATURES.last.match?(file)

        test "Required" do
          assert(required)
        end
      end
    end
  end
end
