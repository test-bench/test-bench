require_relative '../automated_init'

context "Build Session" do
  context "Optional Output Argument" do
    context "Given" do
      output = Output.build

      session = TestBench.build_session(output: output)

      test "Assigns given output to session" do
        assert(session.output.equal?(output))
      end
    end

    context "Omitted" do
      session = TestBench.build_session

      test "Assigns an output to session" do
        refute(session.output.instance_of?(Fixture::Output::Substitute::Output))
      end
    end
  end
end
