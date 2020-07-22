require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Indentation Depth" do
        writer = Output::Writer::Substitute.build
        writer.indentation_depth = 2

        error = Controls::Error.example

        Output::PrintError.(error, writer: writer, reverse_backtraces: false)

        control_text = Controls::Error::Text.example(indentation_depth: 2)

        test do
          assert(writer.written?(control_text))
        end
      end
    end
  end
end
