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
        assert(session.output.level?(Output::Build::Defaults.level))
      end
    end
  end
end
