module TestBench
  module Output
    module Levels
      class Debug
        include TestBench::Fixture::Output

        include Writer::Dependency

        include PrintError

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
      end
    end
  end
end
