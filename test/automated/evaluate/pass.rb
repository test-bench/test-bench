require_relative '../automated_init'

context "Evaluate" do
  context "Pass" do
    session = Session.new

    return_value = TestBench.evaluate(session:) do
      test do
        assert(true)
      end
    end

    test do
      assert(return_value)
    end
  end
end
