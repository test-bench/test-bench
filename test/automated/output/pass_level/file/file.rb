require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "File" do
      output = Output::Levels::Pass.new

      output.writer.enable_styling!

      file_1 = Controls::TestFile.filename
      file_2 = Controls::TestFile::Alternate.filename

      result = Controls::Result.example

      output.enter_file(file_1)

      output.enter_context("Some Context")
      output.exit_context("Some Context", result)

      output.exit_file(file_1, result)

      output.enter_file(file_2)
      output.exit_file(file_2, result)

      test do
        assert(output.writer.written?(<<~TEXT))
        Running #{file_1}
        \e[32mSome Context\e[39m

        Running #{file_2}
        \e[2m(Nothing written)\e[22m

        TEXT
      end
    end
  end
end
