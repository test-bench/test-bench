require_relative '../automated_init'

context "Output" do
  context "Comment" do
    output = Output.new

    output.writer.enable_styling!
    output.writer.indentation_depth = 1

    output.comment("Some comment")

    test "Comment text is indented and written without styling" do
      assert(output.writer.written?("  Some comment\n"))
    end
  end
end
