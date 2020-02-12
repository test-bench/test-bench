require_relative '../automated_init'

context "Runner" do
  context "Multiple Paths" do
    path_1 = Controls::TestFile.example
    path_2 = Controls::TestFile.example

    runner = Run.new(path_1, path_2)

    runner.()

    context "Loads Each Path" do
      [path_1, path_2].each do |path|
        test "Path: #{path.inspect}" do
          assert(runner.session.loaded?(path))
        end
      end
    end
  end
end
