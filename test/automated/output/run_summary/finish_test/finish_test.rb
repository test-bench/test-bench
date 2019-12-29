require_relative '../../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Finish Test" do
      output = Output::Summary::Run.new

      result = Controls::Result.example

      output.test_count = 11

      output.finish_test("Some test", result)

      test "Test count is incremented" do
        assert(output.test_count == 12)
      end
    end
  end
end
