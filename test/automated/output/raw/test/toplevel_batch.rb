require_relative '../../../automated_init'

context "Raw Output" do
  context "Test" do
    context "Toplevel Batch" do
      batch_data = Controls::Output::BatchData::Toplevel.example

      output = Output::Raw.new

      context "Start Test" do
        output.start_test("Some test", batch_data: batch_data)

        test "Sets the current batch" do
          assert(output.current_batch == batch_data)
        end
      end

      context "Finish Test" do
        result = Controls::Result.example

        output.finish_test("Some test", result, batch_data: batch_data)

        test "Unsets the current batch" do
          assert(output.current_batch.nil?)
        end
      end
    end
  end
end
