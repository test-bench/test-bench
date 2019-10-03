require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Text" do
      text = 'Some text'

      context "Text Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.text

        writer.byte_offset = 11

        return_value = writer.text(text)

        test "Writes given text to device" do
          assert(writer.device.string == text)
        end

        test "Returns the writer" do
          assert(return_value == writer)
        end

        test "Writer remains in text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Increases byte offset by the number of bytes written to device" do
          assert(writer.byte_offset == 11 + text.bytesize)
        end
      end

      context "Escape Sequence Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.escape_sequence

        writer.device.write("\e[0")

        writer.byte_offset = 11

        return_value = writer.text(text)

        test "Terminates escape sequence on device, then writes given text" do
          assert(writer.device.string == "\e[0m#{text}")
        end

        test "Returns the writer" do
          assert(return_value == writer)
        end

        test "Writer is changed to text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Increases byte offset by the number of bytes written to device" do
          assert(writer.byte_offset == 11 + 'm'.bytesize + text.bytesize)
        end
      end
    end
  end
end
