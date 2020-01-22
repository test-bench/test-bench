require_relative '../../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Finish Run" do
      context "Pass" do
        result = Controls::Result.example

        context "No Tests Skipped" do
          output = Output::Summary::Run.new
          output.timer.start

          output.writer.enable_styling!

          output.pass_count = 11

          output.finish(result)

          test "Prints number of tests passed in green" do
            assert(output.writer.written?(<<~TEXT))
            Finished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            \e[32m11 passed\e[39m, 0 skipped, 0 failed, 0 total errors

            TEXT
          end
        end

        context "Some Tests Skipped" do
          output = Output::Summary::Run.new
          output.timer.start

          output.writer.enable_styling!

          output.pass_count = 11
          output.skip_count = 22

          output.finish(result)

          test "Prints number of tests passed in green, number of tests skipped in yellow" do
            assert(output.writer.written?(<<~TEXT))
            Finished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            \e[32m11 passed\e[39m, \e[33m22 skipped\e[39m, 0 failed, 0 total errors

            TEXT
          end
        end

        context "No Tests Passed" do
          output = Output::Summary::Run.new
          output.timer.start

          output.finish(result)

          test "Prints number of tests passed in default color" do
            assert(output.writer.written?(<<~TEXT))
            Finished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            0 passed, 0 skipped, 0 failed, 0 total errors

            TEXT
          end
        end
      end
    end
  end
end
