module TestBench
  module Output
    module PrintError
      include Writer::Dependency

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

      def print_error(error)
        PrintError.(error, writer: writer, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces)
      end

      def self.call(error, writer: nil, omit_backtrace_pattern: nil, reverse_backtraces: nil)
        writer ||= Writer.build
        omit_backtrace_pattern ||= Defaults.omit_backtrace_pattern
        reverse_backtraces = Defaults.reverse_backtraces if reverse_backtraces.nil?

        writer.escape_code(:red)

        error(error, writer: writer, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces)

        writer
          .escape_code(:reset_fg)
          .sync
      end

      def self.error(error, writer: nil, omit_backtrace_pattern: nil, reverse_backtraces: nil)
        reverse_backtraces = self.reverse_backtraces if reverse_backtraces.nil?

        if reverse_backtraces
        else
          error_message(error, writer: writer)
          error_backtrace(error, writer: writer, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces)
          error_cause(error, writer: writer, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces)
        end
      end

      def self.error_cause(error, **args)
        error(error.cause, **args) unless error.cause.nil?
      end

      def self.error_message(error, writer: nil)
        caller_location = error.backtrace[0]

        message = error.message

        error_class = error.class.name

        writer
          .indent
          .text("#{caller_location}: ")
          .escape_code(:bold)
          .text("#{message} (")
          .escape_code(:underline)
          .text(error_class)
          .escape_code(:reset_underline)
          .text(")")
          .escape_code(:reset_intensity)
          .newline
      end

      def self.error_backtrace(error, writer: nil, omit_backtrace_pattern: nil, reverse_backtraces: nil)
        writer ||= self.writer
        omit_backtrace_pattern ||= self.omit_backtrace_pattern
        reverse_backtraces = self.reverse_backtraces if reverse_backtraces.nil?

        omitting = false

        backtrace = error.backtrace[1..-1]

        unless reverse_backtraces
          backtrace_iterator = backtrace.each.with_index
        end

        backtrace_iterator.each do |location, _|
          omit = omit_backtrace_pattern.match?(location)

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

            writer.text("from #{location}")
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
