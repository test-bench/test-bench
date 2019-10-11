require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Assertion Failure" do
        output = Output.new
        output.reverse_backtraces = true

        assertion_failure = Fixture::AssertionFailure.build

        output.print_error(assertion_failure)

        test "Writes error message to device" do
          control_text = <<~TEXT
          #{assertion_failure.backtrace[0]}: #{assertion_failure.message} (#{assertion_failure.class.name})
          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
