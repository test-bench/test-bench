require_relative '../automated_init'

context "Evaluate" do
  context "Failed" do
    session = TestBench::Session.new

    result = TestBench.evaluate(session:) do
      test do
        refute(true)
      end
    end

    test do
      refute(result)
    end
  end
end
