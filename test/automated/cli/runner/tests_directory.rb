require_relative '../../automated_init'

context "CLI" do
  context "Runner" do
    context "Tests Directory" do
      tests_directory = Controls::Directory.example

      file_path = Controls::Path::TestFile.example(directory: tests_directory)

      context "No Paths Given" do
        runner = CLI::Run.new
        runner.tests_directory = tests_directory

        runner.()

        test "Runs test files under tests directory" do
          assert(runner.test_run.loaded?(file_path))
        end
      end

      context "Paths Given" do
        runner = CLI::Run.new
        runner.tests_directory = tests_directory

        runner.() do |paths|
          paths << Controls::Path::TestFile.example
        end

        test "Does not run files under tests directory" do
          refute(runner.test_run.loaded?(file_path))
        end
      end
    end
  end
end
