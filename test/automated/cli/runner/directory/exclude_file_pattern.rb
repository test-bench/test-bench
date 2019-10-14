require_relative '../../../automated_init'

context "CLI" do
  context "Runner" do
    context "Directory" do
      context "Exclude File Pattern" do
        runner = CLI::Run.new

        directory = Controls::Directory.example

        file_path_1 = Controls::Path::TestFile.example(filename: 'path_1.rb', directory: directory)
        file_path_2 = Controls::Path::TestFile.example(filename: 'path_2.rb', directory: directory)

        runner.exclude_file_pattern = Regexp.new(file_path_2)
        assert(runner.exclude_file_pattern.match?(file_path_2))

        runner.() do |paths|
          paths << directory
        end

        test "Loads non-excluded file" do
          assert(runner.test_run.loaded?(file_path_1))
        end

        test "Ignores excluded file" do
          refute(runner.test_run.loaded?(file_path_2))
        end
      end
    end
  end
end
