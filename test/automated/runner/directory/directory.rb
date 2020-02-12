require_relative '../../automated_init'

context "Run" do
  context "Directory" do
    directory_1 = Controls::Directory.example
    directory_2 = Controls::Directory.example

    file_path_1 = Controls::TestFile.example(filename: 'path_1.rb', directory: directory_1)

    file_path_2 = Controls::TestFile.example(filename: 'path_2.rb', directory: directory_2)
    file_path_3 = Controls::TestFile.example(filename: 'path_3.rb', directory: directory_2)

    runner = Run.new(directory_1, directory_2)

    runner.()

    context "All Files Under All Directories Are Loaded" do
      [file_path_1, file_path_2, file_path_3].each do |path|
        test "Path: #{path}" do
          assert(runner.session.loaded?(path))
        end
      end
    end
  end
end
