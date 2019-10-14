require_relative '../../../automated_init'

context "CLI" do
  context "Runner" do
    context "Directory" do
      runner = CLI::Run.new

      directory_1 = Controls::Directory.example
      directory_2 = Controls::Directory.example

      file_path_1 = Controls::Path::TestFile.example(filename: 'path_1.rb', directory: directory_1)

      file_path_2 = Controls::Path::TestFile.example(filename: 'path_2.rb', directory: directory_2)
      file_path_3 = Controls::Path::TestFile.example(filename: 'path_3.rb', directory: directory_2)

      runner.() do |paths|
        paths << directory_1
        paths << directory_2
      end

      context "All Files Under All Directories Are Loaded" do
        [file_path_1, file_path_2, file_path_3].each do |path|
          test "Path: #{path}" do
            assert(runner.test_run.loaded?(path))
          end
        end
      end
    end
  end
end
