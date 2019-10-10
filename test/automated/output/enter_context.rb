require_relative '../automated_init'

context "Output" do
  context "Enter Context" do
    context "Title" do
      title = "Some Context"

      output = Output.new

      output.writer.enable_styling!
      output.writer.indentation_depth = 1

      output.enter_context(title)

      test "Title is indented and written in green" do
        assert(output.writer.written?("  \e[32mSome Context\e[39m\n"))
      end

      test "Writer indentation depth is incremented" do
        assert(output.writer.indentation_depth == 2)
      end
    end

    context "No Title" do
      title = nil

      output = Output.new

      output.writer.indentation_depth = 1

      output.enter_context(title)

      test "Nothing is written" do
        refute(output.writer.written?)
      end

      test "Writer indentation depth is unchanged" do
        assert(output.writer.indentation_depth == 1)
      end
    end
  end
end
