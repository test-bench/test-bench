require_relative '../automated_init'

context "Toplevel Context" do
  context "Pass" do
    session = Session::Substitute.build

    return_value = TestBench.context(session: session) do
      assert(true)
    end

    test "Return value" do
      assert(return_value == true)
    end
  end
end
