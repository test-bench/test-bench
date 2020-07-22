require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Newline" do
      newline_character = Controls::Output::NewlineCharacter.example

      context "Text Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.text

        writer.byte_offset = 11

        return_value = writer.newline

        test "Writes newline character to device" do
          assert(writer.device.string == newline_character)
        end

        test "Returns the writer" do
          assert(return_value == writer)
        end

        test "Writer remains in text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Increases byte offset" do
          assert(writer.byte_offset > 11)
        end
      end

      context "Escape Sequence Mode" do
        writer = Output::Writer.new
        writer.mode = Output::Writer::Mode.escape_sequence

        writer.indentation_depth = 2

        writer.device.write("\e[0")

        writer.byte_offset = 11

        return_value = writer.newline

        test "Terminates escape sequence on device, then writes newline character" do
          assert(writer.device.string == "\e[0m#{newline_character}")
        end

        test "Returns the writer" do
          assert(return_value == writer)
        end

        test "Writer is changed to text mode" do
          assert(writer.mode == Output::Writer::Mode.text)
        end

        test "Increases byte offset by at least one more than escape sequence termination" do
          assert(writer.byte_offset > 12)
        end
      end
    end
  end
end
