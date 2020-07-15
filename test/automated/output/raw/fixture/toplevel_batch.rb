require_relative '../../../automated_init'

context "Raw Output" do
  context "Fixture" do
    context "Batch" do
      batch_data = Controls::Output::BatchData::Toplevel.example

      fixture = Controls::Fixture.example

      output = Output::Raw.new

      context "Start Fixture" do
        output.start_fixture(fixture, batch_data: batch_data)

        test "Sets the current batch" do
          assert(output.current_batch == batch_data)
        end
      end

      context "Finish Fixture" do
        result = Controls::Result.example

        output.finish_fixture(fixture, result, batch_data: batch_data)

        test "Unsets the current batch" do
          assert(output.current_batch.nil?)
        end
      end
    end
  end
end
