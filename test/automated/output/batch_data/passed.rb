require_relative '../../automated_init'

context "Output" do
  context "Batch Data" do
    context "Passed" do
      context "Pass" do
        batch_data = Controls::Output::BatchData::Pass.example

        assert(batch_data.result == true)

        test "Passed" do
          assert(batch_data.passed?)
        end
      end

      context "Failure" do
        batch_data = Controls::Output::BatchData::Failure.example

        assert(batch_data.result == false)

        test "Not passed" do
          refute(batch_data.passed?)
        end
      end
    end
  end
end
