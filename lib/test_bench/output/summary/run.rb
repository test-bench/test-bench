module TestBench
  module Output
    module Summary
      class Run
        include Output

        def elapsed_time
          @elapsed_time ||= 0
        end
        attr_writer :elapsed_time

        def error_count
          @error_count ||= 0
        end
        attr_writer :error_count

        def file_count
          @file_count ||= 0
        end
        attr_writer :file_count

        def failure_count
          @failure_count ||= 0
        end
        attr_writer :failure_count

        def pass_count
          @pass_count ||= 0
        end
        attr_writer :pass_count

        def skip_count
          @skip_count ||= 0
        end
        attr_writer :skip_count

        def test_count
          @test_count ||= 0
        end
        attr_writer :test_count

        def timer
          @timer ||= Timer::Substitute.build
        end
        attr_writer :timer

        def writer
          @writer ||= Writer::Substitute.build
        end
        attr_writer :writer

        def configure(writer: nil, styling: nil, device: nil)
          Writer.configure(self, writer: writer, device: device, styling: styling)
          Timer.configure(self)
        end

        def enter_file(_)
          timer.start

          self.file_count += 1
        end

        def exit_file(_, _)
          elapsed_time = timer.stop

          self.elapsed_time += elapsed_time

          elapsed_time
        end

        def error(error)
          self.error_count += 1
        end

        def finish_test(_, result)
          self.test_count += 1

          if result
            self.pass_count += 1
          else
            self.failure_count += 1
          end
        end

        def skip_test(_)
          self.skip_count += 1
        end

        def finish(result)
          failed = !result

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
