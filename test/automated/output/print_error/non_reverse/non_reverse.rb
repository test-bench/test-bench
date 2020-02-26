require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      writer = Output::Writer::Substitute.build

      error = Controls::Error.example

      Output::PrintError.(error, writer: writer, reverse_backtraces: false)

      control_text = Controls::Error::Text.example

      test "Writes error message to device" do
        assert(writer.written?(control_text))
      end
    end
  end
end
