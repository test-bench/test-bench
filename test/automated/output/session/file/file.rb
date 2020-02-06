require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "File" do
      output = Output::Session.new

      output.writer.enable_styling!

      path = Controls::TestFile.path
      result = Controls::Result.example

      output.enter_file(path)

      output.enter_context("Some Context")
      output.exit_context("Some Context", true)

      output.exit_file(path, result)

      test do
        control_text = <<~TEXT
        Running #{path}
        \e[32mSome Context\e[39m

        TEXT

        assert(output.writer.written?(control_text))
      end
    end
  end
end
