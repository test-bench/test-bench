require_relative '../../automated_init'

context "Output" do
  context "Build" do
    context "Default Level" do
      output = Output.build

      default_level = Output::Build::Defaults.level

      test "Is #{default_level.inspect}" do
        assert(output.level?(default_level))
      end
    end
  end
end
