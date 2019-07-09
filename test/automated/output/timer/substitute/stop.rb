require_relative '../../../automated_init'

context "Output" do
  context "Timer" do
    context "Substitute" do
      context "Stop" do
        context "Not Already Stopped" do
          context "Elapsed Time Not Set" do
            substitute = Output::Timer::Substitute.build
            substitute.start

            refute(substitute.stopped?)

            elapsed_time = substitute.stop

            test "Timer is stopped" do
              assert(substitute.stopped?)
            end

            test "Returns zero" do
              assert(elapsed_time.zero?)
            end
          end

          context "Elapsed Time Set" do
            substitute = Output::Timer::Substitute.build
            substitute.start

            control_elapsed_time = Controls::Time::Elapsed.example
            substitute.set(control_elapsed_time)

            elapsed_time = substitute.stop

            test "Timer is stopped" do
              assert(substitute.stopped?)
            end

            test "Returns the value that was set" do
              assert(elapsed_time == control_elapsed_time)
            end
          end
        end

        context "Already Stopped" do
          substitute = Output::Timer::Substitute.build

          assert(substitute.stopped?)

          begin
            substitute.stop
          rescue Output::Timer::Error => error
          end

          test "Raises error" do
            assert(error.instance_of?(Output::Timer::Error))
          end
        end
      end
    end
  end
end
