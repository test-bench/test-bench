require_relative '../automated_init'

context "Toplevel Context" do
  context "Failure" do
    session = Fixture::Session::Substitute.build

    return_value = TestBench.context(session: session) do
      session.fail!
    end

    test "Return value" do
      assert(return_value == false)
    end
  end
end
