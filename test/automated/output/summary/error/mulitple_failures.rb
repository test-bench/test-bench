require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Error" do
      context "Multiple Failures" do
        output = TestBench::Output::Summary.new

        file_1 = Controls::TestFile.filename
        error_1 = Controls::Error.example("Error #1")
        error_2 = Controls::Error.example("Error #2")

        file_2 = Controls::TestFile::Alternate.filename
        error_3 = Controls::Error.example("Error #3")

        output.start

        output.enter_file(file_1)
        output.error(error_1)
        output.error(error_2)
        output.exit_file(file_1, false)

        output.enter_file(file_2)
        output.error(error_3)
        output.exit_file(file_2, false)

        output.finish(false)

        control_text_pattern = Controls::Pattern.example(<<~TEXT)
          Error Summary:
             2: #{file_1}
                #{error_1.backtrace[0]}: #{error_1} (#{error_1.class})
                #{error_2.backtrace[0]}: #{error_2} (#{error_2.class})
             1: #{file_2}
                #{error_3.backtrace[0]}: #{error_3} (#{error_3.class})

        TEXT

        test do
          assert(output.writer.written?(control_text_pattern))
        end
      end
    end
  end
end
