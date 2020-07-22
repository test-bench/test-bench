require_relative '../../automated_init'

context "Output" do
  context "Batch Data" do
    context "Toplevel" do
      context "Depth is Zero" do
        batch_data = Controls::Output::BatchData::Toplevel.example

        assert(batch_data.depth.zero?)

        test "Toplevel" do
          assert(batch_data.toplevel?)
        end
      end

      context "Depth is Greater Than Zero" do
        batch_data = Controls::Output::BatchData.example

        assert(batch_data.depth.nonzero?)

        test "Not toplevel" do
          refute(batch_data.toplevel?)
        end
      end
    end
  end
end
