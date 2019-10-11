require_relative '../../automated_init'

context "Output" do
  context "Summary" do
    context "Start Run" do
      output = Output.new

      assert(output.timer.stopped?)

      output.start_run

      test "Timer is started" do
        assert(output.timer.running?)
      end
    end
  end
end
