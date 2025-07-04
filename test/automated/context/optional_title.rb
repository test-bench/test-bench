require_relative '../automated_init'

context "Context" do
  context "Optional Title Argument" do
    context "Given" do
      session = TestBench::Session::Substitute.build

      TestBench.context("Some Context", session:) do
        #
      end

      recorded = session.one_event?(TestBench::Session::Events::ContextFinished, title: "Some Context")

      test do
        assert(recorded)
      end
    end

    context "Omitted" do
      session = TestBench::Session::Substitute.build

      TestBench.context(session:) do
        #
      end

      recorded = session.one_event?(TestBench::Session::Events::ContextFinished, title: nil)

      test do
        assert(recorded)
      end
    end
  end
end
