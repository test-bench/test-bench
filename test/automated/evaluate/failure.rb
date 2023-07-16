require_relative '../automated_init'

context "Evaluate" do
  context "Failure" do
    session = Session.new

    return_value = TestBench.evaluate(session:) do
      test do
        refute(true)
      end
    end

    test do
      refute(return_value)
    end
  end
end
