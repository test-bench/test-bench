require_relative '../automated_init'

context "Build Session" do
  context "Optional Abort On Error Argument" do
    context "True" do
      abort_on_error = true

      session = TestBench.build_session(abort_on_error: abort_on_error)

      test "Session error policy configured to abort" do
        assert(session.error_policy.instance_of?(Fixture::ErrorPolicy::Abort))
      end
    end

    context "False" do
      abort_on_error = false

      session = TestBench.build_session(abort_on_error: abort_on_error)

      test "Session error policy configured to rescue" do
        assert(session.error_policy.instance_of?(Fixture::ErrorPolicy::Rescue))
      end
    end
  end
end
