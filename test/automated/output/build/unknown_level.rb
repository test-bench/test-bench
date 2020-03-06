require_relative '../../automated_init'

context "Output" do
  context "Build" do
    context "Unknown Level" do
      level = :unknown_level

      test "Is an error" do
        assert_raises(Output::Build::Error) do
          Output.build(level: level)
        end
      end
    end
  end
end
