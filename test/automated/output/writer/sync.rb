require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Sync" do
      context "Text Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.text

        writer.byte_offset = 11

        writer.sync

        test "Writes nothing to device" do
          assert(writer.device.string.empty?)
        end

        test "Writer remains in text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Does not increase byte offset" do
          assert(writer.byte_offset == 11)
        end
      end

      context "Escape Sequence Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.escape_sequence

        writer.device.write("\e[0")

        writer.byte_offset = 11

        writer.sync

        test "Terminates escape sequence on device" do
          assert(writer.device.string == "\e[0m")
        end

        test "Writer is changed to text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Increases byte offset by the number of bytes written to device" do
          assert(writer.byte_offset == 12)
        end
      end
    end
  end
end
