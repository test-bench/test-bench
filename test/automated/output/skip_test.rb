require_relative '../automated_init'

context "Output" do
  context "Skip Test" do
    context "Title" do
      output = Output.new

      output.writer.enable_styling!
      output.writer.indentation_depth = 1

      output.skip_test("Some test")

      test "Title is indented and written in yellow" do
        assert(output.writer.written?("  \e[33mSome test\e[39m\n"))
      end
    end

    context "No Title" do
      title = nil

      output = Output.new

      output.writer.enable_styling!
      output.writer.indentation_depth = 1

      output.skip_test(title)

      test "`Test' is indented and written in yellow" do
        assert(output.writer.written?("  \e[33mTest\e[39m\n"))
      end
    end
  end
end
