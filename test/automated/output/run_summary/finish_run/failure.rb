require_relative '../../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Finish Run" do
      context "Failure" do
        output = Output::Summary::Run.new
        output.timer.start

        output.writer.enable_styling!

        output.test_count = 0
        output.pass_count = 1
        output.skip_count = 2
        output.failure_count = 3
        output.error_count = 4

        result = Controls::Result::Failure.example

        output.finish(result)

        test "Prints summary in red" do
          assert(output.writer.written?(<<~TEXT))
            \e[31mFinished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            1 passed, 2 skipped, \e[1m3 failed\e[22m, \e[1m4 total errors\e[22;39m

          TEXT
        end
      end
    end
  end
end
