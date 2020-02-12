require_relative '../../automated_init'

context "Runner" do
  context "Configure Receiver" do
    context "Paths Given" do
      path_1 = Controls::Path.example
      path_2 = Controls::Path.alternate

      receiver = Struct.new(:run).new

      Run.configure(receiver, path_1, path_2)

      test "Sets paths on configured run" do
        assert(receiver.run.paths == [path_1, path_2])
      end
    end
  end
end
