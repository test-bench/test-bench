module TestBench
  module Output
    class PrintError
      def omit_backtrace_pattern
        @omit_backtrace_pattern ||= Defaults.omit_backtrace_pattern
      end
      attr_writer :omit_backtrace_pattern

      def reverse_backtraces
        instance_variable_defined?(:@reverse_backtraces) ?
          @reverse_backtraces :
          @reverse_backtraces = Defaults.reverse_backtraces
      end
      attr_writer :reverse_backtraces

      def writer
        @writer ||= Writer::Substitute.build
      end
      attr_writer :writer

      def call(error)
        writer.escape_code(:red)

        if reverse_backtraces && error.backtrace.length > 1
          writer
            .indent
            .escape_code(:bold)
            .text("Traceback")
            .escape_code(:reset_intensity)
            .text(" (most recent call last):")
            .newline
        end

        error(error)

        writer
          .escape_code(:reset_fg)
          .sync
      end

      def error(error)
        if reverse_backtraces
          cause(error)
          backtrace(error)
          message(error)
        else
          message(error)
          backtrace(error)
          cause(error)
        end
      end

      def cause(error)
        error(error.cause) unless error.cause.nil?
      end

      def message(error)
        writer
          .indent
          .text("#{error.backtrace[0]}: ")
          .escape_code(:bold)
          .text("#{error.message} (")
          .escape_code(:underline)
          .text(error.class.name)
          .escape_code(:reset_underline)
          .text(")")
          .escape_code(:reset_intensity)
          .newline
      end

      def backtrace(error)
        omitting = false

        backtrace = error.backtrace[1..-1]

        unless reverse_backtraces
          error_backtrace_iterator = backtrace.each
        else
          frame_count = backtrace.count

          number_width = frame_count.to_s.each_char.count

          error_backtrace_iterator = backtrace.reverse_each.map.with_index do |frame, index|
            ordinal = frame_count - index

            ordinal = ordinal.to_s.rjust(number_width, ' ')

            [frame, ordinal]
          end
        end

        error_backtrace_iterator.each do |frame, ordinal|
          omit = omit_backtrace_pattern.match?(frame)

          next if omit && omitting

          writer
            .text("\t")
            .indent

          if omit
            omitting = true

            if reverse_backtraces
              ordinal.gsub!(/[[:digit:]]/, '?')

              writer.text("#{ordinal}: ")
            end

            writer
              .escape_code(:faint)
              .escape_code(:italic)
              .text('*omitted*')
              .escape_code(:reset_italic)
              .escape_code(:reset_intensity)

          else
            omitting = false

            if reverse_backtraces
              writer.text("#{ordinal}: ")
            end

            writer.text("from #{frame}")
          end

          writer.newline
        end
      end

      module Defaults
        def self.omit_backtrace_pattern
          pattern = ENV.fetch('TEST_BENCH_OMIT_BACKTRACE_PATTERN') do
            'test_bench'
          end

          Regexp.new(pattern)
        end

        def self.reverse_backtraces
          Environment::Boolean.fetch('TEST_BENCH_REVERSE_BACKTRACES', false)
        end
      end
    end
  end
end
