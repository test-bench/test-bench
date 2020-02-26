require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Session" do
      output = Output::Summary.new

      result = Controls::Result.example
      output.finish(result)

      control_text = Controls::Output::Summary::Session::Text.example

      control_text_pattern = Controls::Pattern.example(control_text)

      test "Prints summary when session finishes" do
        assert(output.writer.written?(control_text_pattern))
      end
    end
  end
end
