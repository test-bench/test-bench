require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Tests Directory" do
      context do
        tests_directory = Controls::Directory.example

        context "Short Form" do
          parse_arguments = CLI::ParseArguments.new(['-d', tests_directory])

          parse_arguments.()

          test do
            assert(parse_arguments.run.tests_directory == tests_directory)
          end
        end

        context "Long Form" do
          parse_arguments = CLI::ParseArguments.new(['--tests-directory', tests_directory])

          parse_arguments.()

          test do
            assert(parse_arguments.run.tests_directory == tests_directory)
          end
        end

        context "Invalid Directory" do
          tests_directory = Controls::Directory::NonExistent.example

          parse_arguments = CLI::ParseArguments.new(['--tests-directory', tests_directory])

          test "Raises an error" do
            assert_raises(CLI::ParseArguments::Error) do
              parse_arguments.()
            end
          end
        end
      end
    end
  end
end
