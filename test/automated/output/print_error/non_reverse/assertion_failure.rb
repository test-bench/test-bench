require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Assertion Failure" do
        print_error = Output::PrintError.new
        print_error.reverse_backtraces = false

        assertion_failure = Fixture::AssertionFailure.build

        print_error.(assertion_failure)

        test "Writes error message to device" do
          control_text = <<~TEXT
          #{assertion_failure.backtrace[0]}: #{assertion_failure.message} (#{assertion_failure.class.name})
          TEXT

          assert(print_error.writer.written?(control_text))
        end
      end
    end
  end
end
