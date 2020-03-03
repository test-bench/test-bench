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
      end
    end
  end
end
