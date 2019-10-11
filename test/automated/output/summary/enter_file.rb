require_relative '../../automated_init'

context "Output" do
  context "Summary" do
    context "Enter File" do
      output = Output.new

      path = Controls::Path.example

      output.file_count = 11

      output.enter_file(path)

      test "File count is incremented" do
        assert(output.file_count == 12)
      end
    end
  end
end
