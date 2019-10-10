require_relative '../../automated_init'

context "Output" do
  context "Error Details" do
    context "Exit Context" do
      output = Output.new

      output.error_details = "Some error details"

      result = Controls::Result.example

      output.exit_context("Some Context", result)

      test "Writes error details" do
        assert(output.writer.written?(/Some error details/))
      end

      test "Resets error details" do
        assert(output.error_details.nil?)
      end
    end
  end
end
