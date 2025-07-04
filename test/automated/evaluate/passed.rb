require_relative '../automated_init'

context "Evaluate" do
  context "Passed" do
    session = TestBench::Session.new

    result = TestBench.evaluate(session:) do
      test do
        assert(true)
      end
    end

    test do
      assert(result)
    end
  end
end
