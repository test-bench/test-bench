require_relative '../../automated_init'

context "Output" do
  context "Error Details" do
    context "Enter Assert Block" do
      context "Outermost Assert Block Depth" do
        assert_block_depth = Controls::Depth::Outermost.example + 1

        context "Non-Verbose" do
          verbose = false

          context "Block Failed" do
            result = Controls::Result::Failure.example

            output = Output.new
            output.verbose = verbose

            output.assert_block_depth = assert_block_depth

            writer = output.writer
            writer.set_capture("Some text")

            previous_indentation_depth = writer.indentation_depth

            output.exit_assert_block(result)

            test "Error details is set to captured text" do
              assert(output.error_details == "Some text")
            end

            test "Writer stops capturing text" do
              refute(writer.capturing?)
            end

            test "Writer's indentation depth is decreased by two" do
              assert(writer.indentation_depth == previous_indentation_depth - 2)
            end

            test "Assert block depth is decremented" do
              assert(output.assert_block_depth == assert_block_depth - 1)
            end
          end

          context "Block Passed" do
            result = Controls::Result::Pass.example

            output = Output.new
            output.verbose = verbose

            output.assert_block_depth = assert_block_depth

            writer = output.writer
            writer.set_capture("Some text")

            previous_indentation_depth = writer.indentation_depth

            output.exit_assert_block(result)

            test "Error details is not set" do
              assert(output.error_details.nil?)
            end

            test "Writer stops capturing text" do
              refute(writer.capturing?)
            end

            test "Writer's indentation depth is decreased by two" do
              assert(writer.indentation_depth == previous_indentation_depth - 2)
            end

            test "Assert block depth is decremented" do
              assert(output.assert_block_depth == assert_block_depth - 1)
            end
          end
        end

        context "Verbose" do
          result = Controls::Result::Failure.example

          output = Output.new
          output.verbose = true

          output.assert_block_depth = assert_block_depth

          previous_indentation_depth = output.writer.indentation_depth

          output.exit_assert_block(result)

          test "Error details is not set" do
            assert(output.error_details.nil?)
          end

          test "Writer's indentation depth is unchanged" do
            assert(output.writer.indentation_depth == previous_indentation_depth)
          end

          test "Assert block depth is decremented" do
            assert(output.assert_block_depth == assert_block_depth - 1)
          end
        end
      end

      context "Nested Assert Block Depth" do
        assert_block_depth = Controls::Depth::Nested.example

        result = Controls::Result::Failure.example

        output = Output.new

        output.assert_block_depth = assert_block_depth

        writer = output.writer
        writer.set_capture("Some text")

        previous_indentation_depth = writer.indentation_depth

        output.exit_assert_block(result)

        test "Error details is not set" do
          assert(output.error_details.nil?)
        end

        test "Writer does not stop capturing text" do
          assert(writer.capturing?)
        end

        test "Writer's indentation depth is unchanged" do
          assert(writer.indentation_depth == previous_indentation_depth)
        end

        test "Assert block depth is decremented" do
          assert(output.assert_block_depth == assert_block_depth - 1)
        end
      end
    end
  end
end
