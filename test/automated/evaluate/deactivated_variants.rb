require_relative '../automated_init'

context "Evaluate" do
  context "Deactivated Variants" do
    context "_context" do
      session = TestBench::Session::Substitute.build

      TestBench.evaluate(session:) do
        _context "Some Context" do
          #
        end
      end

      context "Context block is skipped" do
        recorded = session.one_event?(
          TestBench::Session::Events::Skipped,
          message: "Some Context"
        )

        test do
          assert(recorded)
        end
      end
    end

    context "_test" do
      session = TestBench::Session::Substitute.build

      TestBench.evaluate(session:) do
        _test "Some test" do
          #
        end
      end

      context "Test block is skipped" do
        recorded = session.one_event?(
          TestBench::Session::Events::Skipped,
          message: "Some test"
        )

        test do
          assert(recorded)
        end
      end
    end
  end
end
