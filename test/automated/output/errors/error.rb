require_relative '../../automated_init'

context "Output" do
  context "Errors" do
    context "Error" do
      error = Controls::Error.example

      output = Output.new

      output.error(error)

      test "Sets previous error attribute to error that was raised" do
        assert(output.previous_error == error)
      end
    end
  end
end
