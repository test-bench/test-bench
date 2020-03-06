require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "File" do
      context "Toplevel Error" do
        output = Output::Levels::Pass.new

        file = Controls::TestFile.filename

        error = Controls::Error.example

        result = Controls::Result::Failure.example

        output.enter_file(file)
        output.error(error)
        output.exit_file(file, result)

        test do
          assert(output.writer.written?(<<~TEXT))
          Running #{file}
          #{Controls::Error::Text.example.chomp}
          TEXT
        end
      end
    end
  end
end
