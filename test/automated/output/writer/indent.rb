require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Indent" do
      context "Text Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.text

        writer.indentation_depth = 2

        writer.byte_offset = 11

        return_value = writer.indent

        test "Writes whitespace in proportion to indentation depth to device" do
          assert(writer.device.string == '    ')
        end

        test "Returns the writer" do
          assert(return_value == writer)
        end

        test "Writer remains in text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Increases byte offset by the number of bytes written to device" do
          assert(writer.byte_offset == 15)
        end
      end

      context "Escape Sequence Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.escape_sequence

        writer.indentation_depth = 2

        writer.device.write("\e[0")

        writer.byte_offset = 11

        return_value = writer.indent

        test "Terminates escape sequence on device, then writes whitespace in proportion to indentation depth" do
          assert(writer.device.string == "\e[0m    ")
        end

        test "Returns the writer" do
          assert(return_value == writer)
        end

        test "Writer is changed to text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Increases byte offset by the number of bytes written to device" do
          assert(writer.byte_offset == 16)
        end
      end
    end
  end
end
