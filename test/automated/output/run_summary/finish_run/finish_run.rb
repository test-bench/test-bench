require_relative '../../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Finish Run" do
      output = Output::Summary::Run.new

      elapsed_time = Controls::Time::Elapsed.example
      output.elapsed_time = elapsed_time

      result = Controls::Result::Failure.example

      output.finish(result)

      test "Prints summary" do
        assert(output.writer.written?(<<~TEXT))
        Finished running 0 files
        Ran 0 tests in #{elapsed_time}s (0.0 tests/second)
        0 passed, 0 skipped, 0 failed, 0 total errors

        TEXT
      end
    end
  end
end
