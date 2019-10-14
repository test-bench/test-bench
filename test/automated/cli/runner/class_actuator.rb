require_relative '../../automated_init'

context "CLI" do
  context "Runner" do
    context "Class Actuator" do
      test_run = Run::Substitute.build

      directory = Controls::Directory.example
      exclude_file_path = Controls::Pattern.example
      file_path = Controls::Path::TestFile.example(directory: directory)

      CLI::Run.(
        directory,
        exclude_file_pattern: exclude_file_path,
        test_run: test_run
      )

      test "Loads tests under the given path" do
        assert(test_run.loaded?(file_path))
      end
    end
  end
end
