require_relative '../../automated_init'

context "Output" do
  context "Timer" do
    context "Stop" do
      context "Not Already Stopped" do
        control_elapsed_time = Controls::Time::Elapsed.example

        t0 = Controls::Time.example(seconds_offset: 0)
        t1 = Controls::Time.example(seconds_offset: control_elapsed_time)

        timer = Output::Timer.new

        timer.start_time = t0
        refute(timer.stopped?)

        elapsed_time = timer.stop(t1)

        test "Timer is stopped" do
          assert(timer.stopped?)
        end

        test "Returns the seconds elapsed since start time" do
          assert(elapsed_time == control_elapsed_time)
        end

        test "Resets start time" do
          assert(timer.start_time.nil?)
        end
      end

      context "Already Stopped" do
        timer = Output::Timer.new

        assert(timer.stopped?)

        begin
          timer.stop
        rescue Output::Timer::Error => error
        end

        test "Raises error" do
          assert(error.instance_of?(Output::Timer::Error))
        end
      end
    end
  end
end
