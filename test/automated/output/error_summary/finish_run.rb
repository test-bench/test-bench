require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Finish Run" do
      result = Controls::Result.example

      context "Errors" do
        output = Output.new

        output.writer.enable_styling!

        output.errors_by_file = {
          'some_test.rb' => 1,
          'other_test.rb' => 11
        }

        output.finish_run(result)

        test "Writes error summary" do
          assert(output.writer.written?(<<~TEXT))
          \e[1;31mError Summary:\e[22;39m
             1: some_test.rb
            11: other_test.rb

          TEXT
        end
      end

      context "No Errors" do
        output = Output.new

        output.finish_run(result)

        test "Does not write error summary" do
          refute(output.writer.written?(/Error summary/))
        end
      end
    end
  end
end
