require_relative '../../../automated_init'

context "Raw Output" do
  context "Load File" do
    context "Nothing Written" do
      output = Output::Raw.new

      output.writer.enable_styling!

      path = Controls::TestFile.filename

      output.enter_file(path)
      output.exit_file(path, Controls::Result.example)

      test do
        assert(output.writer.written?(<<TEXT))
Running #{path}
\e[2m(Nothing written)\e[22m

TEXT
      end
    end
  end
end
