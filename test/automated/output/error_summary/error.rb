require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Error" do
      output = Output.new

      output.file_error_counter = 11

      error = Controls::Error.example

      output.error(error)

      test "Per-file error counter is incremented" do
        assert(output.file_error_counter == 12)
      end
    end
  end
end
