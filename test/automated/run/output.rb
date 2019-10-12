require_relative '../automated_init'

context "Run" do
  context "Output" do
    context "Optional Argument Omitted" do
      run = Run.build

      output = run.output

      test "Output dependency is configured" do
        assert(output.instance_of?(Output))
      end
    end

    context "Optional Argument Given" do
      output = Output.new

      run = Run.build(output: output)

      test "Given output is supplied to run" do
        assert(run.output.equal?(output))
      end
    end
  end
end
