require_relative '../../automated_init'

context "Output" do
  context "Build" do
    context "Default Level" do
      output = Output.build

      default_level = Output::Build::Defaults.level

      default_cls = Output.build(level: default_level).class

      test "Is #{default_level}" do
        assert(output.instance_of?(default_cls))
      end
    end
  end
end
