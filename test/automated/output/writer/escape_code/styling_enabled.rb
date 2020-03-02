require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Escape Code" do
      context "Styling Enabled" do
        code_id = Controls::Output::EscapeCode::ID.example
        escape_code = Controls::Output::EscapeCode.example

        context "Text Mode" do
          writer = Output::Writer.new
          writer.mode = Output::Writer::Mode.text

          writer.styling_enabled = true

          writer.byte_offset = 11

          return_value = writer.escape_code(code_id)

          control_string = "\e[#{escape_code}"

          test "Initiates an escape sequence on device with the given code" do
            assert(writer.device.string == control_string)
          end

          test "Returns the writer" do
            assert(return_value == writer)
          end

          test "Writer is changed to escape sequence mode" do
            assert(writer.mode == Output::Writer::Mode.escape_sequence)
          end

          test "Increases byte offset by the number of bytes written to device" do
            assert(writer.byte_offset == 11 + control_string.bytesize)
          end
        end

        context "Escape Sequence Mode" do
          writer = Output::Writer.new
          writer.mode = Output::Writer::Mode.escape_sequence

          writer.device.write("\e[0")

          writer.styling_enabled = true

          writer.byte_offset = 11

          return_value = writer.escape_code(code_id)

          test "Continues escape sequence on device with the given code" do
            assert(writer.device.string == "\e[0;#{escape_code}")
          end

          test "Returns the writer" do
            assert(return_value == writer)
          end

          test "Writer remains in escape sequence mode" do
            assert(writer.mode == Output::Writer::Mode.escape_sequence)
          end

          test "Increases byte offset by the number of bytes written to device" do
            assert(writer.byte_offset == 11 + ';'.bytesize + escape_code.bytesize)
          end
        end
      end
    end
  end
end
