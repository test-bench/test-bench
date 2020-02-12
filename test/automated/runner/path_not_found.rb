require_relative '../automated_init'

context "Runner" do
  context "Path Not Found" do
    path = Controls::Path.example
    refute(File.exist?(path))

    runner = Run.new(path)

    test "Raises error" do
      assert_raises(Run::Error) do
        runner.()
      end
    end
  end
end
