require_relative '../../automated_init'

context "Runner" do
  context "Configure Receiver" do
    context "Optional Output Argument Given" do
      receiver = Struct.new(:run).new

      output = Output.build

      session = Fixture::Session.build

      Run.configure(receiver, output: output, session: session)

      test "Sets output dependency of session" do
        assert(session.output == output)
      end
    end
  end
end
