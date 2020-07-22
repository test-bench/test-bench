require_relative '../../automated_init'

context "Output" do
  context "Timer" do
    context "Start" do
      context "Not Already Running" do
        timer = Output::Timer.new

        refute(timer.running?)

        timer.start

        test "Sets start time" do
          assert(timer.start_time.instance_of?(Time))
        end

        test "Timer is running" do
          assert(timer.running?)
        end
      end

      context "Already Running" do
        timer = Output::Timer.new
        timer.start

        assert(timer.running?)

        assert(timer.mode == Output::Timer::Mode.running)

        begin
          timer.start
        rescue Output::Timer::Error => error
        end

        test "Raises error" do
          assert(error.instance_of?(Output::Timer::Error))
        end
      end
    end
  end
end
