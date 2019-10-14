require_relative './automated_init'

context "Set Output" do
  context do
    session = Session.new

    output = Output.build

    TestBench.set_output(output, session: session)

    test "Sets the session's output to the one given" do
      assert(session.output.equal?(output))
    end
  end

  context "Given Multiple Outputs" do
    output_1 = Output.build
    output_2 = Output.build

    session = Session.new

    TestBench.set_output([output_1, output_2], session: session)

    output = session.output or fail

    test "Assigns a multiple output" do
      assert(output.instance_of?(Output::Multiple))
    end

    test "Assigned output writes to each given output" do
      assert(output.registered?(output_1))
      assert(output.registered?(output_2))
    end
  end
end
