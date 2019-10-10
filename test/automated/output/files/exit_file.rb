require_relative '../../automated_init'

context "Output" do
  context "Summary" do
    context "Exit File" do
      path = Controls::Path.example
      result = Controls::Result.example

      context "Text Was Written Since File Was Entered" do
        output = Output.new

        output.writer.byte_offset = 11

        output.previous_byte_offset = 0

        output.exit_file(path, result)

        test "Writes nothing" do
          refute(output.writer.written?)
        end
      end

      context "No Text Was Written Since File Was Entered" do
        output = Output.new

        output.writer.enable_styling!
        output.writer.byte_offset = 11

        output.previous_byte_offset = 11

        output.exit_file(path, result)

        test "Writes notice that no output was written" do
          assert(output.writer.written?(<<~TEXT))
          \e[2m(Nothing written)\e[22m

          TEXT
        end
      end
    end
  end
end
