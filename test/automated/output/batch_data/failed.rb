require_relative '../../automated_init'

context "Output" do
  context "Batch Data" do
    context "Failed" do
      context "Failure" do
        batch_data = Controls::Output::BatchData::Failure.example

        assert(batch_data.result == false)

        test "Failed" do
          assert(batch_data.failed?)
        end
      end

      context "Pass" do
        batch_data = Controls::Output::BatchData::Pass.example

        assert(batch_data.result == true)

        test "Not failed" do
          refute(batch_data.failed?)
        end
      end
    end
  end
end
