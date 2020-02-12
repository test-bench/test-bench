require_relative '../automated_init'

context "Build Session" do
  session = TestBench.build_session

  test "Builds a session" do
    assert(session.instance_of?(TestBench::Session))
  end

  test "Output dependency is configured" do
    default_cls = Output.build.class

    assert(session.output.instance_of?(default_cls))
  end
end
