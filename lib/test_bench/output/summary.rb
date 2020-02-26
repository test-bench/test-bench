module TestBench
  module Output
    class Summary
      include Fixture::Output

      include Writer::Dependency

      def file_count
        @file_count ||= 0
      end
      attr_writer :file_count

      def test_count
        @test_count ||= 0
      end
      attr_writer :test_count

      def pass_count
        @pass_count ||= 0
      end
      attr_writer :pass_count

      def skip_count
        @skip_count ||= 0
      end
      attr_writer :skip_count

      def failure_count
        @failure_count ||= 0
      end
      attr_writer :failure_count

      def error_count
        @error_count ||= 0
      end
      attr_writer :error_count

      def elapsed_time
        @elapsed_time ||= 0
      end
      attr_writer :elapsed_time

      def timer
        @timer ||= Timer::Substitute.build
      end
      attr_writer :timer

      def errors_by_file
        @errors_by_file ||= Hash.new do |hash, key|
          hash[key] = []
        end
      end
      attr_writer :errors_by_file

      attr_accessor :current_file

      def enter_file(file)
        timer.start

        self.current_file = file
      end

      def exit_file(_, _)
        elapsed_time = timer.stop

        self.elapsed_time += elapsed_time

        self.file_count += 1
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

      def error(error)
        errors_by_file[current_file] << error

        self.error_count += 1
      end

      def finish(_)
        error_summary

        session_summary
      end

      def session_summary
        Session.(file_count: file_count, test_count: test_count, pass_count: pass_count, skip_count: skip_count, failure_count: failure_count, error_count: error_count, elapsed_time: elapsed_time, writer: writer)
      end

      def error_summary
        return if errors_by_file.empty?

        writer
          .escape_code(:bold)
          .escape_code(:red)
          .text('Error Summary:')
          .escape_code(:reset_intensity)
          .escape_code(:reset_fg)
          .newline

        errors_by_file.each do |file, errors|
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
    end
  end
end
