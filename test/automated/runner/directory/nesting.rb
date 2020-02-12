require_relative '../../automated_init'

context "Runner" do
  context "Directory" do
    context "Nesting" do
      root_directory = Controls::Directory.example

      directory = File.join(root_directory, 'some_subdirectory')
      Dir.mkdir(directory)

      file_path = Controls::TestFile.example(directory: directory)

      runner = Run.new(root_directory)

      runner.()

      test "Runs file located in subdirectory" do
        assert(runner.session.loaded?(file_path))
      end
    end
  end
end
