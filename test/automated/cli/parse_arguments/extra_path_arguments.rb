require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Extra Path Arguments" do
      path_1 = Controls::Path.example
      path_2 = Controls::Path.alternate

      argv = ['-a', path_1, path_2]

      return_value = CLI::ParseArguments.(argv)

      test "Returns the unparsed arguments" do
        assert(return_value == [path_1, path_2])
      end
    end
  end
end
