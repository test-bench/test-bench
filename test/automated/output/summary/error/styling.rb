require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Error" do
      context "Styling" do
        output = TestBench::Output::Summary.new

        output.writer.enable_styling!

        file = Controls::Output::Summary::Error::Text.file
        error = Controls::Output::Summary::Error::Text.error

        output.start

        output.enter_file(file)
        output.error(error)
        output.exit_file(file, false)

        output.finish(false)

        control_text_pattern = Controls::Pattern.example(<<~TEXT)
          \e[1;31mError Summary:\e[22;39m
             1: #{file}
                \e[31m#{error.backtrace[0]}: \e[1m#{error} (\e[4m#{error.class}\e[24m)\e[22m
          \e[39m
        TEXT

        test do
          assert(output.writer.written?(control_text_pattern))
        end
      end
    end
  end
end
