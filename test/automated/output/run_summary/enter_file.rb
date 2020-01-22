require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Enter File" do
      output = Output::Summary::Run.new
      assert(output.timer.stopped?)

      previous_elapsed_time = output.elapsed_time or fail

      output.file_count = 11

      path = Controls::Path.example

      output.enter_file(path)

      test "File count is incremented" do
        assert(output.file_count == 12)
      end

      test "Elapsed time is unchanged" do
        assert(output.elapsed_time == previous_elapsed_time)
      end

      test "Timer is started" do
        assert(output.timer.running?)
      end
    end
  end
end
