require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Exit File" do
      path = "some_test.rb"
      result = Controls::Result.example

      context "Per-File Error Counter is Non-Zero" do
        file_error_counter = 11

        output = Output.new

        assert(output.errors_by_file.empty?)

        output.file_error_counter = file_error_counter

        output.exit_file(path, result)

        test "File and error counter are recorded" do
          assert(output.errors_by_file[path] == file_error_counter)
        end

        test "Per-File Error counter is reset" do
          assert(output.file_error_counter.zero?)
        end
      end

      context "Per-File Error Counter is Zero" do
        file_error_counter = 0

        output = Output.new

        output.file_error_counter = file_error_counter

        output.exit_file(path, result)

        test "File and error counter are not recorded" do
          assert(output.errors_by_file.empty?)
        end
      end
    end
  end
end
