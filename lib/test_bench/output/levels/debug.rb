module TestBench
  module Output
    module Levels
      class Debug
        include TestBench::Fixture::Output

        include Writer::Dependency

        include PrintError

        include Output::Summary::Error
        include Output::Summary::Run

        def previous_byte_offset
          @previous_byte_offset ||= 0
        end
        attr_writer :previous_byte_offset

        def self.build(omit_backtrace_pattern: nil, reverse_backtraces: nil, writer: nil, styling: nil, device: nil)
          instance = new

          instance.omit_backtrace_pattern = omit_backtrace_pattern unless omit_backtrace_pattern.nil?
          instance.reverse_backtraces = reverse_backtraces unless reverse_backtraces.nil?

          Writer.configure(instance, writer: writer, styling: styling, device: device)
          instance
        end

        def comment(text)
          writer
            .indent
            .text(text)
            .newline
        end

        def error(error)
          print_error(error)
        end

        def finish_test(title, result)
          writer.decrease_indentation

          fg_color = result ? :green : :red

          writer.indent

          writer
            .escape_code(fg_color)
            .text("Finished test")

          unless title.nil?
            writer
              .text(' ')
              .escape_code(:bold)
              .text(title.inspect)
              .escape_code(:reset_intensity)
          end

          writer
            .text(" (Result: #{result ? 'pass' : 'failure'})")
            .escape_code(:reset_fg)
            .newline
        end

        def skip_test(title)
          writer.indent

          writer
            .escape_code(:yellow)
            .text("Skipped test")

          unless title.nil?
            writer
              .text(' ')
              .escape_code(:bold)
              .text(title.inspect)
              .escape_code(:reset_intensity)
          end

          writer
            .escape_code(:reset_fg)
            .newline
        end

        def start_test(title)
          if title.nil?
            text = "Starting test"
          else
            text = "Starting test #{title.inspect}"
          end

          writer
            .indent
            .escape_code(:cyan)
            .text(text)
            .escape_code(:reset_fg)
            .newline

          writer.increase_indentation
        end

        def enter_context(title)
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
          return if title.nil?

          writer.decrease_indentation

          fg_color = result ? :green : :red

          text = "Finished context #{title.inspect} (Result: #{result ? 'pass' : 'failure'})"

          writer
            .indent
            .escape_code(:faint)
            .escape_code(:italic)
            .escape_code(fg_color)
            .text(text)
            .escape_code(:reset_fg)
            .escape_code(:reset_italic)
            .escape_code(:reset_intensity)
            .newline

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

        def start_fixture(fixture)
          fixture_class = fixture.class.inspect

          writer
            .indent
            .escape_code(:blue)
            .text("Starting fixture (Fixture: #{fixture_class})")
            .escape_code(:reset_fg)
            .newline

          writer.increase_indentation
        end

        def finish_fixture(fixture, result)
          fixture_class = fixture.class.inspect

          writer.decrease_indentation

          writer
            .indent
            .escape_code(:magenta)
            .text("Finished fixture (Fixture: #{fixture_class}, Result: #{result ? 'pass' : 'failure'})")
            .escape_code(:reset_fg)
            .newline

          writer.newline if writer.indentation_depth.zero?
        end

        def enter_file(file)
          text = "Running #{file}"

          writer.text(text).newline

          self.previous_byte_offset = writer.byte_offset
        end

        def exit_file(file, _)
          unless writer.byte_offset > previous_byte_offset
            writer
              .escape_code(:faint)
              .text("(Nothing written)")
              .escape_code(:reset_intensity)
              .newline

            writer.newline
          end
        end

        def enter_assert_block(caller_location)
          text = "Entered assert block (Caller Location: #{caller_location})"

          writer
            .indent
            .escape_code(:blue)
            .text(text)
            .escape_code(:reset_fg)
            .newline

          writer.increase_indentation
        end

        def exit_assert_block(caller_location, result)
          writer.decrease_indentation

          text = "Exited assert block (Caller Location: #{caller_location}, Result: #{result ? 'pass' : 'failure'})"

          writer
            .indent
            .escape_code(:cyan)
            .text(text)
            .escape_code(:reset_fg)
            .newline
        end
      end
    end
  end
end
