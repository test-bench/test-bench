require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Current Predicate" do
      writer = Output::Writer.new

      writer.byte_offset = 11

      context "Current" do
        context "Given Byte Offset Exceeds Writer's Byte Offset" do
          byte_offset = 12

          test do
            assert(writer.current?(byte_offset) == true)
          end
        end

        context "Given Byte Offset Equals Writer's Byte Offset" do
          byte_offset = 11

          test do
            assert(writer.current?(byte_offset) == true)
          end
        end
      end

      context "Not Current" do
        context "Given Byte Offset Precedes Writer's Byte Offset" do
          byte_offset = 10

          test do
            assert(writer.current?(byte_offset) == false)
          end
        end
      end
    end
  end
end
