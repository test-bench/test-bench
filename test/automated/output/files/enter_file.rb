require_relative '../../automated_init'

context "Output" do
  context "Summary" do
    context "Enter File" do
      output = Output.new
      output.writer.enable_styling!

      output.writer.byte_offset = 11

      path = Controls::Path.example

      output.enter_file(path)

      control_text = <<~TEXT
      Running #{path}
      TEXT

      test "Writes that file is being run" do
        assert(output.writer.written?(control_text))
      end

      test "Previous byte offset is set" do
        assert(output.previous_byte_offset == 11 + control_text.bytesize)
      end
    end
  end
end
