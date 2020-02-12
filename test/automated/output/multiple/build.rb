require_relative '../../automated_init'

context "Output" do
  context "Multiple" do
    context "Build" do
      output_1 = Controls::Output.example
      output_2 = Controls::Output.example

      multiple = Output::Multiple.build(output_1, output_2)

      [output_1, output_2].each_with_index do |output, index|
        context "Given Output ##{index + 1}" do
          test "Registered" do
            assert(multiple.registered?(output))
          end
        end
      end
    end
  end
end
