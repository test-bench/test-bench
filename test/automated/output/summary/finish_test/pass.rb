require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Finish Test" do
      context "Pass" do
        output = Output.new

        result = Controls::Result::Pass.example

        output.pass_count = 11

        output.finish_test("Some test", result)

        test "Pass count is incremented" do
          assert(output.pass_count == 12)
        end

        test "Failure count is not incremented" do
          assert(output.failure_count.zero?)
        end
      end
    end
  end
end
