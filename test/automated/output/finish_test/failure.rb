require_relative '../../automated_init'

context "Output" do
  context "Finish Test" do
    context "Failure" do
      result = Controls::Result::Failure.example

      context "Title" do
        title = "Some test"

        output = Output.new

        output.writer.enable_styling!

        output.finish_test(title, result)

        test "Title is written in bold red" do
          assert(output.writer.written?("\e[1;31m#{title}\e[39;22m\n"))
        end
      end

      context "No Title" do
        title = nil

        output = Output.new

        output.writer.enable_styling!

        output.finish_test(title, result)

        test "`Test' is written in bold red" do
          assert(output.writer.written?("\e[1;31mTest\e[39;22m\n"))
        end
      end
    end
  end
end
