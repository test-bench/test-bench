require_relative '../../../automated_init'

context "Raw Output" do
  context "Load File" do
    context "Error" do
      output = Output::Raw.new

      path = Controls::TestFile.filename

      error = Controls::Error.example

      output.enter_file(path)
      output.error(error)
      output.exit_file(path, Controls::Result::Failure.example)

      test do
        assert(output.writer.written?(<<TEXT))
Running #{path}
#{Controls::Error::Text.example.chomp}
TEXT
      end
    end
  end
end
