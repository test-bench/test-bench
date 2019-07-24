require_relative './interactive_init'

TestBench.evaluate do
  context "Some Context" do
    test "Some test" do
      assert(true)
    end

    test "Some other test" do
      refute(true)
    end
  end
end
