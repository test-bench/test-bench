require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Error" do
      context "Pass" do
        output = TestBench::Output::Summary.new

        file = Controls::TestFile.filename

        output.start

        output.enter_file(file)
        output.exit_file(file, true)

        output.finish(true)

        control_text_pattern = Controls::Pattern.example("Error Summary:")

        test "Does not print error summary" do
          refute(output.writer.written?(control_text_pattern))
        end
      end
    end
  end
end
