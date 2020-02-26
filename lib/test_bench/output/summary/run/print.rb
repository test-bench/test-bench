module TestBench
  module Output
    module Summary
      module Run
        module Print
          extend self

          def call(file_count: nil, test_count: nil, pass_count: nil, skip_count: nil, failure_count: nil, error_count: nil, elapsed_time: nil, writer: nil)
            file_count ||= 0
            test_count ||= 0
            pass_count ||= 0
            skip_count ||= 0
            failure_count ||= 0
            error_count ||= 0
            elapsed_time ||= 0
            writer ||= Writer.build

            failed = error_count > 0

            if elapsed_time.nonzero?
              tests_per_second = test_count / elapsed_time
            end

            if failed
              writer.escape_code(:red)
            end

            writer
              .text("Finished running #{numeric_label(file_count, 'file')}")
              .newline
              .text("Ran %s in %.3fs (%.1f tests/second)" % [
                numeric_label(test_count, 'test'),
                elapsed_time,
                tests_per_second || 0])
              .newline

            if pass_count.nonzero? && !failed
              writer
                .escape_code(:green)
                .text("#{pass_count} passed")
                .escape_code(:reset_fg)
            else
              writer.text("#{pass_count} passed")
            end

            writer.text(", ")

            if skip_count.nonzero? && !failed
              writer
                .escape_code(:yellow)
                .text("#{skip_count} skipped")
                .escape_code(:reset_fg)
            else
              writer.text("#{skip_count} skipped")
            end

            writer.text(", ")

            if failure_count.nonzero?
              writer
                .escape_code(:bold)
                .text("#{failure_count} failed")
                .escape_code(:reset_intensity)
            else
              writer.text("0 failed")
            end

            writer.text(", ")

            if failed
              writer
                .escape_code(:bold)
                .text(numeric_label(error_count, 'total error'))
                .escape_code(:reset_intensity)
                .escape_code(:reset_fg)
            else
              writer.text("0 total errors")
            end

            2.times do
              writer.newline
            end
          end

          def numeric_label(number, label, plural_text=nil)
            plural_text ||= 's'

            if number == 1
              "#{number} #{label}"
            else
              "#{number} #{label}#{plural_text}"
            end
          end
        end
      end
    end
  end
end
