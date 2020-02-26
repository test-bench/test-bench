require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Error" do
      output = TestBench::Output::Summary.new

      file = Controls::Output::Summary::Error::Text.file
      error = Controls::Output::Summary::Error::Text.error

      output.start

      output.enter_file(file)
      output.error(error)
      output.exit_file(file, false)

      output.finish(false)

      control_text = Controls::Output::Summary::Error::Text.example

      control_text_pattern = Controls::Pattern.example(control_text)

      test do
        assert(output.writer.written?(control_text_pattern))
      end
    end
  end
end
