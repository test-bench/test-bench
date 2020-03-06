require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Tests Per Second" do
      writer = Output::Writer::Substitute.build

      test_count = 50
      elapsed_time = 10

      Output::Summary::Run.(
        test_count: test_count,
        elapsed_time: elapsed_time,
        writer: writer
      )

      test "Prints the number of tests divided by the elapsed time" do
        assert(writer.written?(<<~TEXT))
          Finished running 0 files
          Ran 50 tests in 10.000s (5.0 tests/second)
          0 passed, 0 skipped, 0 failed, 0 total errors

        TEXT
      end
    end
  end
end
