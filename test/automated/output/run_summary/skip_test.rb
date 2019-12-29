require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Skip Test" do
      output = Output::Summary::Run.new

      output.skip_count = 11

      output.skip_test("Some test")

      test "Skip count is incremented" do
        assert(output.skip_count == 12)
      end

      test "Test count is not incremented" do
        assert(output.test_count.zero?)
      end
    end
  end
end
