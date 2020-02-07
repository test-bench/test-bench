require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "File" do
        path = Controls::TestFile.example

        error = Controls::Error.example

        output = Output::Session.new

        Output::PrintError.configure(output, writer: output.writer)

        output.enter_file(path)
        output.error(error)
        output.exit_file(path, false)

        test "Prints the error after the file name" do
          control_text = <<~TEXT
          Running #{path}
          #{error.backtrace[0]}: #{error.message} (#{error.class.name})
          \tfrom #{error.backtrace[1]}
          \tfrom #{error.backtrace[2]}

          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
