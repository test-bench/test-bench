require_relative '../automated_init'

context "Run" do
  context "Start" do
    run = Run.new

    run.start

    context "Output" do
      test "Start run" do
        recorded = run.output.recorded_once?(:start_run)

        assert(recorded)
      end
    end
  end
end
