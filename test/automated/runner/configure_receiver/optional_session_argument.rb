require_relative '../../automated_init'

context "Runner" do
  context "Configure Receiver" do
    context "Optional Session Argument" do
      receiver_cls = Struct.new(:run)

      context "Given" do
        receiver = receiver_cls.new

        session = Fixture::Session.build

        Run.configure(receiver, session: session)

        test "Sets session dependency of run" do
          assert(receiver.run.session == session)
        end
      end

      context "Omitted" do
        receiver = receiver_cls.new

        Run.configure(receiver)

        test "Sets session dependency to singleton" do
          assert(receiver.run.session.equal?(TestBench.session))
        end
      end
    end
  end
end
