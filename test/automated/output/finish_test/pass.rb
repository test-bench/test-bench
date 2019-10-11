require_relative '../../automated_init'

context "Output" do
  context "Finish Test" do
    context "Pass" do
      result = Controls::Result::Pass.example

      context "Title" do
        output = Output.new

        output.writer.enable_styling!

        output.finish_test("Some test", result)

        test "Title is written in green" do
          assert(output.writer.written?("\e[32mSome test\e[39m\n"))
        end
      end

      context "No Title" do
        title = nil

        output = Output.new

        output.finish_test(title, result)

        test "Nothing is written" do
          refute(output.writer.written?)
        end
      end
    end
  end
end
