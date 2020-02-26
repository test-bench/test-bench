require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Pass" do
      context "No Tests Skipped" do
        writer = Output::Writer::Substitute.build
        writer.enable_styling!

        Output::Summary::Run.(
          pass_count: 11,
          skip_count: 0,
          writer: writer
        )

        test "Prints number of tests passed in green" do
          assert(writer.written?(<<~TEXT))
            Finished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            \e[32m11 passed\e[39m, 0 skipped, 0 failed, 0 total errors

          TEXT
        end
      end

      context "Some Tests Skipped" do
        writer = Output::Writer::Substitute.build
        writer.enable_styling!

        Output::Summary::Run.(
          pass_count: 11,
          skip_count: 22,
          writer: writer
        )

        test "Prints number of tests passed in green, number of tests skipped in yellow" do
          assert(writer.written?(<<~TEXT))
            Finished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            \e[32m11 passed\e[39m, \e[33m22 skipped\e[39m, 0 failed, 0 total errors

          TEXT
        end
      end

      context "No Tests Passed and No Tests Skipped" do
        writer = Output::Writer::Substitute.build
        writer.enable_styling!

        Output::Summary::Run.(
          pass_count: 0,
          skip_count: 0,
          writer: writer
        )

        test "Prints number of tests passed and number of tests skipped in default color" do
          assert(writer.written?(<<~TEXT))
            Finished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            0 passed, 0 skipped, 0 failed, 0 total errors

          TEXT
        end
      end
    end
  end
end
