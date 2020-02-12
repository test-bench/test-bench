require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Exit File" do
      output = Output::Summary::Run.new
      assert(output.timer.stopped?)

      previous_elapsed_time = 10
      output.elapsed_time = previous_elapsed_time

      elapsed_time = Controls::Time::Elapsed.example
      output.timer.set(elapsed_time)

      path = Controls::Path.example
      result = Controls::Result.example

      output.exit_file(path, result)

      test "Elapsed time is increased by timer result" do
        control_elapsed_time = previous_elapsed_time + elapsed_time

        assert(output.elapsed_time == control_elapsed_time)
      end

      test "Timer is stopped" do
        assert(output.timer.stopped?)
      end
    end
  end
end
