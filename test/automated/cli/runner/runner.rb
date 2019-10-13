require_relative '../../automated_init'

context "CLI" do
  context "Runner" do
    run = CLI::Run.new

    run.()

    test "Test run is started" do
      assert(run.test_run.started?)
    end

    test "Test run is finished" do
      assert(run.test_run.finished?)
    end
  end
end
