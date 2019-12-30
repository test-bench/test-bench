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

        error(error)

        writer
          .escape_code(:reset_fg)
          .sync
      end

      def error(error)
        if reverse_backtraces
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

        error_backtrace_iterator = backtrace.each

        error_backtrace_iterator.each do |frame, _|
          omit = omit_backtrace_pattern.match?(frame)

          next if omit && omitting

          writer
            .text("\t")
            .indent

          if omit
            omitting = true

            writer
              .escape_code(:faint)
              .escape_code(:italic)
              .text('*omitted*')
              .escape_code(:reset_italic)
              .escape_code(:reset_intensity)

          else
            omitting = false

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
