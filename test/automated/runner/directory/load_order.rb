require_relative '../../automated_init'

context "Runner" do
  context "Directory" do
    context "Load Order" do
      directory = Controls::Directory.example

      output_file = Tempfile.new

      path_1 = Controls::TestFile.example(filename: 'a_path.rb', directory: directory)
      path_2 = Controls::TestFile.example(filename: 'b_path.rb', directory: directory)
      path_3 = Controls::TestFile.example(filename: 'c_path.rb', directory: directory)

      runner = Run.new(directory)

      runner.()

      files_loaded = runner.session.output.matching_records(:exit_file).map do |record|
        path, _ = record.data
        path
      end

      test "Loads files in alphanumeric order by path name" do
        assert(files_loaded == [path_1, path_2, path_3])
      end
    end
  end
end
