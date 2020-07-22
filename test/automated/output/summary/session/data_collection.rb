require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Session" do
      context "Data Collection" do
        output = Output::Summary.new

        elapsed_time = Controls::Time::Elapsed.example

        output.timer.elapsed_time = elapsed_time

        Controls::Output::Exercise.(output)

        elapsed_time = Controls::Time::Elapsed::Text.example
        tests_per_second = Controls::Time::Elapsed::PerSecond::Text.example

        control_text_pattern = Controls::Pattern.example(<<~TEXT)
          Finished running 1 file
          Ran 1 test in #{elapsed_time} (#{tests_per_second} tests/second)
          1 passed, 1 skipped, 0 failed, 1 total error
        TEXT

        test do
          assert(output.writer.written?(control_text_pattern))
        end
      end
    end
  end
end
