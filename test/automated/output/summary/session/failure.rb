require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Session" do
      context "Failure" do
        writer = Output::Writer::Substitute.build
        writer.enable_styling!

        Output::Summary::Session.(
          failure_count: 1,
          error_count: 2,
          writer: writer
        )

        test "Prints summary in red" do
          assert(writer.written?(<<~TEXT))
            \e[31mFinished running 0 files
            Ran 0 tests in 0.000s (0.0 tests/second)
            0 passed, 0 skipped, \e[1m1 failed\e[22m, \e[1m2 total errors\e[22;39m

          TEXT
        end
      end
    end
  end
end
