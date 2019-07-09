require_relative '../../../automated_init'

context "Output" do
  context "Timer" do
    context "Substitute" do
      context "Start" do
        context "Not Already Running" do
          substitute = Output::Timer::Substitute.build
          refute(substitute.running?)

          substitute.start

          test "Timer is running" do
            assert(substitute.running?)
          end
        end

        context "Already Running" do
          substitute = Output::Timer::Substitute.build
          substitute.start

          assert(substitute.running?)

          begin
            substitute.start
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
