require_relative '../../../automated_init'

context "CLI" do
  context "Runner" do
    context "Directory" do
      context "Load Order" do
        runner = CLI::Run.new

        output = Output::Substitute.build
        Run.configure(runner, output: output)

        directory = Controls::Directory.example

        output_file = Tempfile.new

        test_file_text = <<~RUBY
        File.open(#{output_file.path.inspect}, 'a') { |f| f.puts(__FILE__) }
        RUBY

        path_1 = Controls::Path::TestFile.example(filename: 'a_path.rb', text: test_file_text, directory: directory)
        path_2 = Controls::Path::TestFile.example(filename: 'b_path.rb', text: test_file_text, directory: directory)
        path_3 = Controls::Path::TestFile.example(filename: 'c_path.rb', text: test_file_text, directory: directory)

        runner.() do |paths|
          paths << directory
        end

        files_loaded = File.read(output_file.path).split

        test "Loads files in alphanumeric order by path name" do
          assert(files_loaded == [path_1, path_2, path_3])
        end
      end
    end
  end
end
