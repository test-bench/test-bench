require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Assertion Failure" do
        writer = Output::Writer::Substitute.build

        caller_location = Controls::CallerLocation.example

        assertion_failure = Fixture::AssertionFailure.build(caller_location)

        Output::PrintError.(assertion_failure, writer: writer, reverse_backtraces: true)

        control_text = Controls::Error::Text::Assertion.example(caller_location: caller_location)

        test "Writes error message to device" do
          assert(writer.written?(control_text))
        end
      end
    end
  end
end
