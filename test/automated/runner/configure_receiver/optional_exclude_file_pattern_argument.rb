require_relative '../../automated_init'

context "Runner" do
  context "Configure Receiver" do
    context "Optional Exclude File Pattern Argument Given" do
      receiver = Struct.new(:run).new

      exclude_file_pattern = Controls::Pattern.example

      Run.configure(receiver, exclude_file_pattern: exclude_file_pattern)

      test "Sets exclude file pattern setting" do
        assert(receiver.run.exclude_file_pattern == exclude_file_pattern)
      end
    end
  end
end
