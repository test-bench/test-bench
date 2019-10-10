require_relative '../automated_init'

context "Output" do
  context "Skip Context" do
    context "Title" do
      output = Output.new

      output.writer.enable_styling!
      output.writer.indentation_depth = 1

      output.skip_context("Some Context")

      test "Title is indented and written in yellow" do
        assert(output.writer.written?("  \e[33mSome Context\e[39m\n"))
      end
    end

    context "No Title" do
      title = nil

      output = Output.new

      output.skip_context(title)

      test "Nothing is written" do
        refute(output.writer.written?)
      end
    end
  end
end
