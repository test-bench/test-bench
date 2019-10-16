require_relative '../../automated_init'

context "Output" do
  context "Error Details" do
    context "Enter Assert Block" do
      caller_location = Controls::CallerLocation.example

      context "Outermost Assert Block Depth" do
        assert_block_depth = Controls::Depth::Outermost.example

        context "Non-Verbose" do
          output = Output.new
          output.verbose = false

          output.assert_block_depth = assert_block_depth

          previous_indentation_depth = output.writer.indentation_depth

          output.enter_assert_block(caller_location)

          test "Writer starts capturing text" do
            assert(output.writer.capturing?)
          end

          test "Writer's indentation depth is increased by two" do
            assert(output.writer.indentation_depth == previous_indentation_depth + 2)
          end

          test "Assert block depth is incremented" do
            assert(output.assert_block_depth == assert_block_depth + 1)
          end
        end

        context "Verbose" do
          output = Output.new
          output.verbose = true

          output.assert_block_depth = assert_block_depth

          previous_indentation_depth = output.writer.indentation_depth

          output.enter_assert_block(caller_location)

          test "Writer does not start capturing text" do
            refute(output.writer.capturing?)
          end

          test "Writer's indentation depth is unchanged" do
            assert(output.writer.indentation_depth == previous_indentation_depth)
          end

          test "Assert block depth is incremented" do
            assert(output.assert_block_depth == assert_block_depth + 1)
          end
        end
      end

      context "Nested Assert Block Depth" do
        assert_block_depth = Controls::Depth::Nested.example

        output = Output.new
        output.verbose = false

        output.assert_block_depth = assert_block_depth

        previous_indentation_depth = output.writer.indentation_depth

        output.enter_assert_block(caller_location)

        test "Writer does not start capturing text" do
          refute(output.writer.capturing?)
        end

        test "Writer's indentation depth is unchanged" do
          assert(output.writer.indentation_depth == previous_indentation_depth)
        end

        test "Assert block depth is incremented" do
          assert(output.assert_block_depth == assert_block_depth + 1)
        end
      end
    end
  end
end
