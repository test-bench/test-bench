require_relative '../../automated_init'

context "Raw Output" do
  context "Current Batch" do
    context "Toplevel Batch" do
      batch_data = Controls::Output::BatchData::Toplevel.example

      raw_output = Output::Raw.new

      context "Batch Starting" do
        raw_output.batch_starting(batch_data)

        test "Sets the current batch" do
          assert(raw_output.current_batch == batch_data)
        end
      end

      context "Batch Finished" do
        raw_output.batch_finished(batch_data)

        test "Resets the current batch" do
          assert(raw_output.current_batch.nil?)
        end
      end
    end

    context "Non Toplevel Batch" do
      batch_data = Controls::Output::BatchData.example

      context "Batch Starting" do
        raw_output = Output::Raw.new

        raw_output.batch_starting(batch_data)

        test "Does not set the current batch" do
          assert(raw_output.current_batch.nil?)
        end
      end

      context "Batch Finished" do
        raw_output = Output::Raw.new

        raw_output.current_batch = Controls::Output::BatchData.example

        raw_output.batch_starting(batch_data)

        test "Does not reset the current batch" do
          refute(raw_output.current_batch.nil?)
        end
      end
    end
  end
end
