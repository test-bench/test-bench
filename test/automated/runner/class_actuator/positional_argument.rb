require_relative '../../automated_init'

context "Runner" do
  context "Class Actuator" do
    context "Positional Argument" do
      session = Session::Substitute.build

      directory = Controls::Directory.example
      path_1 = Controls::TestFile.example(directory: directory)
      path_2 = Controls::TestFile.example

      Run.(directory, path_2, session: session)

      test "Loads all given paths" do
        assert(session.loaded?(path_1))
        assert(session.loaded?(path_2))
      end
    end
  end
end
