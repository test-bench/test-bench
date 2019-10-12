require_relative '../automated_init'

context "Run" do
  context "Abort On Error" do
    context "Enabled" do
      run = Run.build(abort_on_error: true)

      error_policy = run.error_policy

      test "Error policy is abort" do
        assert(error_policy.instance_of?(Fixture::ErrorPolicy::Abort))
      end
    end

    context "Disabled" do
      run = Run.build(abort_on_error: false)

      error_policy = run.error_policy

      test "Error policy is rescue" do
        assert(error_policy.instance_of?(Fixture::ErrorPolicy::Rescue))
      end
    end
  end
end
