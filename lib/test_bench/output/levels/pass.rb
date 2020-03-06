module TestBench
  module Output
    module Levels
      class Pass
        include TestBench::Fixture::Output

        include Writer::Dependency

        include PrintError

        attr_accessor :previous_error

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

        def finish_test(title, result)
          writer.indent

          if writer.styling?
            unless result && title.nil?
              writer.escape_code(:bold) unless result

              fg_color = result ? :green : :red

              writer
                .escape_code(fg_color)
                .text(title || 'Test')
                .escape_code(:reset_fg)

              writer.escape_code(:reset_intensity) unless result

              writer.newline
            end
          else
            text = String.new("Finished test")
            text << " #{title.inspect}" unless title.nil?
            text << " (Result: #{result ? 'pass' : 'failure'})"

            writer.text(text).newline
          end

          unless previous_error.nil?
            writer.increase_indentation

            print_previous_error

            writer.decrease_indentation
          end
        end

        def skip_test(title)
          writer.indent

          if writer.styling?
            writer
              .escape_code(:yellow)
              .text(title || 'Test')
              .escape_code(:reset_fg)

            writer.newline
          else
            text = String.new("Skipped test")
            text << " #{title.inspect}" unless title.nil?

            writer.text(text).newline
          end
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
          print_previous_error unless previous_error.nil?

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
      end
    end
  end
end
