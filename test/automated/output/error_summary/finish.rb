require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Finish" do
      result = Controls::Result.example

      context "Errors" do
        output = Output::Summary::Error.new

        output.writer.enable_styling!

        output.enter_file('some_test.rb')
        error_1 = Controls::Error.example('Error #1')
        output.error(error_1)

        output.enter_file('other_test.rb')
        error_2 = Controls::Error.example('Error #2')
        output.error(error_2)
        error_3 = Controls::Error.example('Error #3')
        output.error(error_3)

        output.finish(result)

        test "Writes error summary" do
          assert(output.writer.written?(<<~TEXT))
          \e[1;31mError Summary:\e[22;39m
             1: some_test.rb
                \e[31m#{error_1.backtrace[0]}: \e[1m#{error_1} (#{error_1.class})\e[22;39m
             2: other_test.rb
                \e[31m#{error_2.backtrace[0]}: \e[1m#{error_2} (#{error_2.class})\e[22;39m
                \e[31m#{error_3.backtrace[0]}: \e[1m#{error_3} (#{error_3.class})\e[22;39m

          TEXT
        end
      end

      context "No Errors" do
        output = Output::Summary::Error.new

        output.finish(result)

        test "Does not write error summary" do
          refute(output.writer.written?(/Error summary/))
        end
      end
    end
  end
end
