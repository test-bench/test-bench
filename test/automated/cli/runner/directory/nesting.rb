require_relative '../../../automated_init'

context "CLI" do
  context "Runner" do
    context "Directory" do
      context "Nesting" do
        runner = CLI::Run.new

        root_directory = Controls::Directory.example

        directory = File.join(root_directory, 'some_subdirectory')
        Dir.mkdir(directory)

        file_path = Controls::Path::TestFile.example(directory: directory)

        runner.() do |paths|
          paths << root_directory
        end

        test "Runs file located in subdirectory" do
          assert(runner.test_run.loaded?(file_path))
        end
      end
    end
  end
end
