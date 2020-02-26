require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    output = Controls::Output::Summary::Error.example

    file = Controls::Output::Summary::Error::Text.file
    error = Controls::Output::Summary::Error::Text.error

    output.start

    output.enter_file(file)
    output.error(error)
    output.exit_file(file, false)

    output.finish(false)

    control_text = Controls::Output::Summary::Error::Text.example

    test do
      assert(output.writer.written?(control_text))
    end
  end
end
