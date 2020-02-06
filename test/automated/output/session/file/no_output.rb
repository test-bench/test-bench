require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "File" do
      context "No Output" do
        output = Output::Session.new

        output.writer.enable_styling!

        path = Controls::TestFile.path
        result = Controls::Result.example

        output.enter_file(path)
        output.exit_file(path, result)

        test do
          control_text = <<~TEXT
          Running #{path}
          \e[2m(Nothing written)\e[22m

          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
