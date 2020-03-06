module TestBench
  module Output
    module Levels
      class Pass
        include TestBench::Fixture::Output

        include Writer::Dependency

        include PrintError

        attr_accessor :previous_error

        def previous_byte_offset
          @previous_byte_offset ||= 0
        end
        attr_writer :previous_byte_offset

        def assert_block_stack
          @assert_block_stack ||= AssertBlockStack.new(writer)
        end
        attr_writer :assert_block_stack

        def test_stack
          @test_stack ||= []
        end
        attr_writer :test_stack

        def comment(text)
          writer
            .indent
            .text(text)
            .newline
        end

        def error(error)
          self.previous_error = error
        end

        def print_previous_error
          print_error(previous_error)

          self.previous_error = nil
        end

        def start_test(_)
          test_stack.push(true)
        end

        def finish_test(title, result)
          test_stack.pop

          unless result && title.nil?
            writer.indent

            writer.escape_code(:bold) unless result

            fg_color = result ? :green : :red

            writer
              .escape_code(fg_color)
              .text(title || 'Test')
              .escape_code(:reset_fg)

            writer.escape_code(:reset_intensity) unless result

            writer.newline
          end

          unless previous_error.nil?
            writer.increase_indentation

            print_previous_error

            writer.decrease_indentation
          end

          unless result
            assert_block_stack.print_captured_text
          end
        end

        def skip_test(title)
          writer.indent

          writer
            .escape_code(:yellow)
            .text(title || 'Test')
            .escape_code(:reset_fg)

          writer.newline
        end

        def enter_context(title)
          test_stack.push(false)

          return if title.nil?

          writer
            .indent
            .escape_code(:green)
            .text(title)
            .escape_code(:reset_fg)
            .newline

          writer.increase_indentation
        end

        def exit_context(title, result)
          test_stack.pop

          print_previous_error unless previous_error.nil?

          unless result
            assert_block_stack.print_captured_text
          end

          return if title.nil?

          writer.decrease_indentation

          writer.newline if writer.indentation_depth.zero?
        end

        def skip_context(title)
          return if title.nil?

          writer
            .indent
            .escape_code(:yellow)
            .text(title)
            .escape_code(:reset_fg)
            .newline

          writer.newline if writer.indentation_depth.zero?
        end

        def enter_file(file)
          text = "Running #{file}"

          writer.text(text).newline

          self.previous_byte_offset = writer.byte_offset
        end

        def exit_file(file, result)
          print_previous_error unless previous_error.nil?

          unless result
            assert_block_stack.print_captured_text
          end

          unless writer.byte_offset > previous_byte_offset
            writer
              .escape_code(:faint)
              .text("(Nothing written)")
              .escape_code(:reset_intensity)
              .newline

            writer.newline
          end
        end

        def finish_fixture(_, result)
          print_previous_error unless previous_error.nil?

          unless result
            assert_block_stack.print_captured_text
          end
        end

        def enter_assert_block(_)
          inside_test = inside_test?

          test_stack.push(false)

          assert_block_stack.push

          writer.increase_indentation
          writer.increase_indentation if inside_test
        end

        def exit_assert_block(_, result)
          test_stack.pop

          print_previous_error unless previous_error.nil?

          unless result
            assert_block_stack.print_captured_text
          end

          discard_captured_text = result

          assert_block_stack.pop(discard_captured_text)

          writer.decrease_indentation if inside_test?
          writer.decrease_indentation
        end

        def inside_test?
          test_stack[-1]
        end

        class AssertBlockStack
          def stack
            @stack ||= []
          end

          attr_accessor :captured_text

          attr_reader :writer

          def initialize(writer)
            @writer = writer
          end

          def push
            capture_text = String.new

            previous_device = writer.device

            writer.device = StringIO.new(capture_text)

            entry = Entry.new(capture_text, previous_device)

            stack.push(entry)

            entry
          end

          def pop(discard)
            entry = stack.pop

            writer.device = entry.previous_device

            unless discard
              self.captured_text = entry.capture_text
            end

            entry
          end

          def print_captured_text
            return if captured_text.nil?

            writer.text(captured_text)

            self.captured_text = nil
          end

          def inside_test?
            test_stack[-1]
          end

          Entry = Struct.new(:capture_text, :previous_device)
        end
      end
    end
  end
end
