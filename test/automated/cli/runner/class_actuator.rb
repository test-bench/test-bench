require_relative '../../automated_init'

context "CLI" do
  context "Runner" do
    context "Class Actuator" do
      test_run = Run::Substitute.build

      directory = Controls::Directory.example
      file_path = Controls::Path::TestFile.example(directory: directory)

      CLI::Run.(directory, test_run: test_run)

      test "Loads tests under the given path" do
        assert(test_run.loaded?(file_path))
      end
    end
  end
end
