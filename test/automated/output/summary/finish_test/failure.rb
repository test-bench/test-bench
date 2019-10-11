require_relative '../../../automated_init'

context "Output" do
  context "Summary" do
    context "Finish Test" do
      context "Failure" do
        output = Output.new

        result = Controls::Result::Failure.example

        output.failure_count = 11

        output.finish_test("Some test", result)

        test "Failure count is incremented" do
          assert(output.failure_count == 12)
        end

        test "Pass count is not incremented" do
          assert(output.pass_count.zero?)
        end
      end
    end
  end
end
