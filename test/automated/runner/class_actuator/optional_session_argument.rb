require_relative '../../automated_init'

context "Runner" do
  context "Class Actuator" do
    context "Optional Session Argument" do
      original_session = TestBench.session

      path = Controls::TestFile.example

      context "Block Argument" do
        session = Fixture::Session.build

        global_session_set = nil
        Run.(session: session) do |run|
          global_session_set = TestBench.session.equal?(session)

          run.path(path)
        end

        global_session_restored = TestBench.session.equal?(original_session)

        test "Sets the global session" do
          assert(global_session_set)
        end

        test "Restores the original global session after block is executed" do
          assert(global_session_restored)
        end
      end

      context "Positional Argument" do
        session = Fixture::Session.build

        Run.(path, session: session)

        global_session_unchanged = TestBench.session.equal?(original_session)

        test "Leaves the global session unchanged" do
          assert(global_session_unchanged)
        end
      end

    ensure
      TestBench.session = original_session
    end
  end
end
