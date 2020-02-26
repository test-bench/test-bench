require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Module" do
        writer = Output::Writer::Substitute.build

        output = Controls::Output::PrintError.example(reverse_backtraces: false, writer: writer)

        error = Controls::Error.example

        output.print_error(error)

        control_text = Controls::Error::Text.example

        test "Writes error message to device" do
          assert(writer.written?(control_text))
        end
      end
    end
  end
end
