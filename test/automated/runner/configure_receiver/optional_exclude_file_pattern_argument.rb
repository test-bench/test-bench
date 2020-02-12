require_relative '../../automated_init'

context "Runner" do
  context "Configure Receiver" do
    context "Optional Exclude Argument Given" do
      receiver = Struct.new(:run).new

      exclude_pattern = Controls::Pattern.example

      Run.configure(receiver, exclude: exclude_pattern)

      test "Sets exclude file setting" do
        assert(receiver.run.exclude_pattern == exclude_pattern)
      end
    end
  end
end
