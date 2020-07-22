require_relative '../../../../automated_init'

context "Raw Output" do
  context "Test" do
    context "Batch Data" do
      context "Failing Batch" do
        batch_data = Controls::Output::BatchData::Failure.example

        result = batch_data.result

        context "Test Has Title" do
          output = Output::Raw.new

          output.start_test("Some test", batch_data: batch_data)
          output.comment("Mark")
          output.finish_test("Some test", result, batch_data: batch_data)

          test "Prints the test result, then indents the batch" do
            puts output.writer.device.string
            assert(output.writer.written?(<<~TEXT))
            Some test (failed)
              Mark
            TEXT
          end
        end

        context "Test Lacks Title" do
          output = Output::Raw.new

          title = nil

          output.start_test(title, batch_data: batch_data)
          output.comment("Mark")
          output.finish_test(title, result, batch_data: batch_data)

          test "Prints the test result, then indents the batch" do
            assert(output.writer.written?(<<~TEXT))
            Test (failed)
              Mark
            TEXT
          end
        end
      end
    end
  end
end
