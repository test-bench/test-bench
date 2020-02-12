require_relative '../automated_init'

context "Runner" do
  test_file = Controls::TestFile.example

  runner = Run.new(test_file)

  runner.()

  test "Test file located at path is loaded" do
    assert(runner.session.loaded?(test_file))
  end

  test "Session is started" do
    assert(runner.session.started?)
  end

  test "Session is finished" do
    assert(runner.session.finished?)
  end
end
