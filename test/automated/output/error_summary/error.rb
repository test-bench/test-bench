require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Error" do
      error = Controls::Error.example

      context "Current File" do
        output = Output::Summary::Error.new

        path = Controls::Path.example
        output.enter_file(path)

        output.error(error)

        test "Error is appended to current file's error list" do
          assert(output.current_file.errors == [error])
        end
      end

      context "No Current File" do
        output = Output::Summary::Error.new

        error = Controls::Error.example

        test "Error is ignored" do
          refute_raises do
            output.error(error)
          end
        end
      end
    end
  end
end
