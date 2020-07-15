require_relative '../../../automated_init'

context "Raw Output" do
  context "Context" do
    context "Toplevel Batch" do
      batch_data = Controls::Output::BatchData::Toplevel.example

      output = Output::Raw.new

      context "Enter Context" do
        output.enter_context("Some Context", batch_data: batch_data)

        test "Sets the current batch" do
          assert(output.current_batch == batch_data)
        end
      end

      context "Exit Context" do
        result = Controls::Result.example

        output.exit_context("Some Context", result, batch_data: batch_data)

        test "Resets the current batch" do
          assert(output.current_batch.nil?)
        end
      end
    end
  end
end
