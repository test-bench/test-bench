require_relative '../automated_init'

context "Output" do
  context "None Level" do
    output = Output::Levels::None.build

    test "Is a null output" do
      assert(output.is_a?(Fixture::Output::Null))
    end
  end
end
