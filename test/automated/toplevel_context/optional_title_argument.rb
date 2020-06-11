require_relative '../automated_init'

context "Toplevel Context" do
  context "Optional Title Argument" do
    context "Given" do
      session = Fixture::Session::Substitute.build

      TestBench.context("Some Context", session: session) do
        #
      end

      recorded_title = session.output.exit_context_recorded? do |title|
        title == "Some Context"
      end

      test do
        assert(recorded_title)
      end
    end

    context "Omitted" do
      session = Fixture::Session::Substitute.build

      TestBench.context(session: session) do
        block_context = self
      end

      recorded_no_title = session.output.exit_context_recorded? do |title|
        title.nil?
      end

      test do
        assert(recorded_no_title)
      end
    end
  end
end
