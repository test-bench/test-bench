require_relative '../../../../automated_init'

context "Raw Output" do
  context "Test" do
    context "Batch Data" do
      context "Verbose" do
        context "Passing Batch" do
          batch_data = Controls::Output::BatchData::Pass.example

          result = batch_data.result

          context "Test Has Title" do
            output = Output::Raw.new

            output.verbose = true

            output.start_test("Some test", batch_data: batch_data)
            output.comment("Mark")
            output.finish_test("Some test", result, batch_data: batch_data)

            batch_ignored = output.writer.written?(<<~TEXT)
            Starting test "Some test"
              Mark
            Some test
            TEXT

            test "Prints the test as if there were no batch" do
              assert(batch_ignored)
            end
          end

          context "Test Lacks Title" do
            output = Output::Raw.new

            output.verbose = true

            title = nil

            output.start_test(title, batch_data: batch_data)
            output.comment("Mark")
            output.finish_test(title, result, batch_data: batch_data)

            batch_ignored = output.writer.written?(<<~TEXT)
            Starting test
              Mark
            Test
            TEXT

            test "Prints the test as if there were no batch" do
              assert(batch_ignored)
            end
          end
        end

        context "Failing Batch" do
          batch_data = Controls::Output::BatchData::Failure.example

          result = batch_data.result

          context "Test Has Title" do
            output = Output::Raw.new

            output.verbose = true

            output.start_test("Some test", batch_data: batch_data)
            output.comment("Mark")
            output.finish_test("Some test", result, batch_data: batch_data)

            batch_ignored = output.writer.written?(<<~TEXT)
            Starting test "Some test"
              Mark
            Some test (failed)
            TEXT

            test "Prints the test as if there were no batch" do
              assert(batch_ignored)
            end
          end

          context "Test Lacks Title" do
            output = Output::Raw.new

            output.verbose = true

            title = nil

            output.start_test(title, batch_data: batch_data)
            output.comment("Mark")
            output.finish_test(title, result, batch_data: batch_data)

            batch_ignored = output.writer.written?(<<~TEXT)
            Starting test
              Mark
            Test (failed)
            TEXT

            test "Prints the test as if there were no batch" do
              assert(batch_ignored)
            end
          end
        end
      end
    end
  end
end
