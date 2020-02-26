module TestBench
  module Output
    module Summary
      module Error
        include Writer::Dependency

        def self.included(cls)
          cls.prepend(OutputMethods)
        end

        def error_summary_errors
          @error_summary_errors ||= Hash.new do |hash, key|
            hash[key] = []
          end
        end
        attr_writer :error_summary_errors

        attr_accessor :error_summary_current_file

        def error_summary
          return if error_summary_errors.empty?

          writer
            .escape_code(:bold)
            .escape_code(:red)
            .text('Error Summary:')
            .escape_code(:reset_intensity)
            .escape_code(:reset_fg)
            .newline

          error_summary_errors.each do |file, errors|
            error_count = errors.count

            writer
              .text(error_count.to_s.rjust(4, ' '))
              .text(": #{file}")
              .newline

            errors.each do |error|
              writer
                .text('      ')
                .escape_code(:red)

              PrintError.error_message(error, writer: writer)

              writer.escape_code(:reset_fg)
            end
          end

          writer.newline
        end

        module OutputMethods
          def enter_file(file)
            super

            self.error_summary_current_file = file
          end

          def error(error)
            super

            current_file = error_summary_current_file

            self.error_summary_errors[current_file] << error
          end

          def finish(_)
            super

            error_summary
          end
        end
      end
    end
  end
end
