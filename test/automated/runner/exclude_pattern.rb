require_relative '../automated_init'

context "Runner" do
  context "Exclude Pattern" do
    file_path_1 = Controls::TestFile.example(filename: 'path_1.rb')
    file_path_2 = Controls::TestFile.example(filename: 'path_2.rb')

    runner = Run.new(file_path_1, file_path_2)

    runner.exclude_pattern = Controls::Pattern.example(file_path_2)
    assert(runner.exclude_pattern.match?(file_path_2))

    runner.()

    test "Loads non-excluded file" do
      assert(runner.session.loaded?(file_path_1))
    end

    test "Ignores excluded file" do
      refute(runner.session.loaded?(file_path_2))
    end
  end
end
