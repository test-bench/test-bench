require_relative '../automated_init'

context "Runner" do
  context "Optional Block Argument" do
    path_1 = Controls::TestFile.example
    path_2 = Controls::TestFile.example

    context "Given" do
      runner = Run.new(path_1)

      runner.() do |paths|
        paths << path_2
      end

      test "Test file added by block is loaded" do
        assert(runner.session.loaded?(path_2))
      end

      test "Test file located at runner's path is not loaded" do
        refute(runner.session.loaded?(path_1))
      end

      test "Session is started" do
        assert(runner.session.started?)
      end

      test "Session is finished" do
        assert(runner.session.finished?)
      end
    end

    context "Omitted" do
      runner = Run.new(path_1)

      test "Test file located at runner's path is loaded" do
        refute(runner.session.loaded?(path_1))
      end
    end
  end
end
