require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Enter File" do
      output = Output::Summary::Error.new
      assert(output.files.empty?)

      path = Controls::Path.example

      output.enter_file(path)

      test "Starts new file entry" do
        refute(output.files.empty?)
      end

      context "Current File" do
        current_file = output.current_file or fail

        test "Path attribute is set" do
          assert(current_file.path == path)
        end

        test "Error list is initialized" do
          assert(current_file.errors == [])
        end
      end
    end
  end
end
