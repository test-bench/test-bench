require_relative './interactive_init'

TestBench.activate

context "Some Context" do
  test "Some test" do
    assert(true)
  end

  test "Some other test" do
    refute(true)
  end
end
