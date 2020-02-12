require_relative './automated_init'

context "Deactivation Variants" do
  context "_context" do
    session = Fixture::Session::Substitute.build

    fixture = TestBench.fixture(session)

    fixture.instance_exec do
      _context "Some Context" do
        #
      end
    end

    test "Skips the context block" do
      recorded_skip_context = session.output.skip_context_recorded_once? do |title|
        title == "Some Context"
      end

      assert(recorded_skip_context)
    end
  end

  context "_test" do
    session = Fixture::Session::Substitute.build

    fixture = TestBench.fixture(session)

    fixture.instance_exec do
      _test "Some test" do
        #
      end
    end

    test "Skips the test block" do
      recorded_skip_test = session.output.skip_test_recorded_once? do |title|
        title == "Some test"
      end

      assert(recorded_skip_test)
    end
  end
end
