require_relative '../automated_init'

context "Runner" do
  context "Failure" do
    test_file = Controls::TestFile::Failure.example

    runner = Run.new(test_file)

    output = Output::Substitute.build

    Fixture::Session.configure(runner, output: output)

    begin
      runner.()
    rescue Controls::Error::Example
    end

    test "Session is finished" do
      assert(runner.session.finished?)
    end
  end
end
