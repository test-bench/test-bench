require_relative '../../../automated_init'

context "CLI" do
  context "Runner" do
    context "File" do
      path = Controls::Path::TestFile.example

      context "Path Does Not Match Exclude File Pattern" do
        runner = CLI::Run.new

        runner.exclude_file_pattern = Controls::Pattern::None.example
        refute(runner.exclude_file_pattern.match?(path))

        runner.() do |paths|
          paths << path
        end

        test "File is loaded" do
          assert(runner.test_run.loaded?(path))
        end
      end

      context "Path Matches Exclude File Pattern" do
        runner = CLI::Run.new

        runner.exclude_file_pattern = Regexp.new(path)
        assert(runner.exclude_file_pattern.match?(path))

        runner.() do |paths|
          paths << path
        end

        test "File is not loaded" do
          refute(runner.test_run.loaded?(path))
        end
      end
    end
  end
end
