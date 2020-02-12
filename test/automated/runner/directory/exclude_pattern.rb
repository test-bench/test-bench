require_relative '../../automated_init'

context "Runner" do
  context "Directory" do
    context "Exclude Pattern" do
      directory = Controls::Directory.example

      file_path_1 = Controls::TestFile.example(filename: 'path_1.rb', directory: directory)
      file_path_2 = Controls::TestFile.example(filename: 'path_2.rb', directory: directory)

      runner = Run.new(directory)

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
end
