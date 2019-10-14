require_relative '../../../automated_init'

context "CLI" do
  context "Runner" do
    context "File" do
      path_1 = Controls::Path::TestFile.example
      path_2 = Controls::Path::TestFile.example

      runner = CLI::Run.new

      runner.() do |paths|
        paths << path_1
        paths << path_2
      end

      context "All Paths Are Loaded" do
        [path_1, path_2].each do |path|
          test "Path: #{path}" do
            assert(runner.test_run.loaded?(path))
          end
        end
      end
    end
  end
end
