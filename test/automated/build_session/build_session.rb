require_relative '../automated_init'

context "Build Session" do
  session = TestBench.build_session

  test "Builds a session" do
    assert(session.instance_of?(TestBench::Session))
  end

  test "Output dependency is configured" do
    default_level = Output::Build::Defaults.level

    assert(session.output.level?(default_level))
  end
end
