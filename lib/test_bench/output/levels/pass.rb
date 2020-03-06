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

        def enter_file(file)
          text = "Running #{file}"

          writer.text(text).newline

          self.previous_byte_offset = writer.byte_offset
        end

        def exit_file(file, _)
          print_previous_error unless previous_error.nil?

          unless writer.byte_offset > previous_byte_offset
            writer
              .escape_code(:faint)
              .text("(Nothing written)")
              .escape_code(:reset_intensity)
              .newline

            writer.newline
          end
        end
      end
    end
  end
end
