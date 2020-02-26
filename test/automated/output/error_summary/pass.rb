require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Pass" do
      output = Controls::Output::Summary::Error.example

      file = Controls::TestFile.filename

      output.start

      output.enter_file(file)
      output.exit_file(file, true)

      output.finish(true)

      test "Writes nothing" do
        refute(output.writer.written?)
      end
    end
  end
end
