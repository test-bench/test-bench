require_relative '../../automated_init'

context "CLI" do
  context "Runner" do
    runner = CLI::Run.new

    runner.()

    test "Test run is started" do
      assert(runner.test_run.started?)
    end

    test "Test run is finished" do
      assert(runner.test_run.finished?)
    end
  end
end
