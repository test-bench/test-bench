require_relative '../../automated_init'

context "Output" do
  context "Context Exited Is Handled" do
    context "Outermost Context" do
      indentation_depth = Controls::Depth::Outermost.example + 1

      output = Output.new
      output.writer.indentation_depth = indentation_depth

      result = Controls::Result.example

      output.exit_context("Some Context", result)

      test "Newline character is written" do
        newline_character = Controls::Output::NewlineCharacter.example

        assert(output.writer.written?(newline_character))
      end
    end
  end
end
