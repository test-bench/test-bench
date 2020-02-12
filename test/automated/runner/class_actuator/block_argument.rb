require_relative '../../automated_init'

context "Runner" do
  context "Class Actuator" do
    context "Block Argument" do
      session = Session::Substitute.build

      directory = Controls::Directory.example
      path_1 = Controls::TestFile.example(directory: directory)
      path_2 = Controls::TestFile.example

      Run.(session: session) do |paths|
        paths << directory
        paths << path_2
      end

      test "Loads all given paths" do
        assert(session.loaded?(path_1))
        assert(session.loaded?(path_2))
      end
    end
  end
end
