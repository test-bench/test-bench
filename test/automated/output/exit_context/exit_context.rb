require_relative '../../automated_init'

context "Output" do
  context "Exit Context" do
    result = Controls::Result.example

    indentation_depth = Controls::Depth::Nested.example

    context "Title" do
      title = "Some Context"

      output = Output.new

      output.writer.indentation_depth = indentation_depth

      output.exit_context(title, result)

      test "Nothing is written" do
        refute(output.writer.written?)
      end

      test "Writer indentation depth is decremented" do
        assert(output.writer.indentation_depth == indentation_depth - 1)
      end
    end

    context "No Title" do
      title = nil

      output = Output.new

      output.writer.indentation_depth = indentation_depth

      output.exit_context(title, result)

      test "Writer indentation depth is unchanged" do
        assert(output.writer.indentation_depth == indentation_depth)
      end
    end
  end
end
