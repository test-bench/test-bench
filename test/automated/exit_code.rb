require_relative './automated_init'

context "Exit Code" do
  context "Pass, No Deactivated Tests" do
    session = Fixture::Session.build

    exit_code = TestBench.exit_code(session)

    test "Zero" do
      assert(exit_code == 0)
    end
  end

  context "Pass, Deactivated Tests" do
    session = Fixture::Session.build

    session.skip!

    context "Fail On Deactivated Tests" do
      exit_code = TestBench.exit_code(session, fail_deactivated_tests: true)

      test "Two" do
        assert(exit_code == 2)
      end
    end

    context "Do Not Fail On Deactivated Tests" do
      exit_code = TestBench.exit_code(session, fail_deactivated_tests: false)

      test "Zero" do
        assert(exit_code == 0)
      end
    end
  end

  context "Failure" do
    session = Fixture::Session.build

    session.fail!

    context "Fail On Deactivated Tests" do
      exit_code = TestBench.exit_code(session, fail_deactivated_tests: true)

      test "One" do
        assert(exit_code == 1)
      end
    end
  end
end
