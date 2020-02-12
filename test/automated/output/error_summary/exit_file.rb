require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Exit File" do
      path = Controls::Path.example

      context "File Had Failures" do
        result = Controls::Result::Failure.example

        output = Output::Summary::Error.new
        output.enter_file(path)

        output.exit_file(path, result)

        test "Current file remains in list of files" do
          assert(output.files.map(&:path) == [path])
        end
      end

      context "File Did Not Have Failures" do
        result = Controls::Result::Pass.example

        output = Output::Summary::Error.new
        output.enter_file(path)

        output.exit_file(path, result)

        test "Current file is removed from list of files" do
          assert(output.files == [])
        end
      end
    end
  end
end
