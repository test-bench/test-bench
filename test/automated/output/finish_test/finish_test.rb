require_relative '../../automated_init'

context "Output" do
  context "Finish Test" do
    result = Controls::Result.example

    output = Output.new

    output.writer.indentation_depth = 1

    output.finish_test("Some test", result)

    test "Title is indented and written" do
      assert(output.writer.written?("  Some test\n"))
    end
  end
end
