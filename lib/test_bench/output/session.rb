module TestBench
  module Output
    class Session
      include Output

      def writer
        @writer ||= Writer::Substitute.build
      end
      attr_writer :writer

      def verbose
        instance_variable_defined?(:@verbose) ?
          @verbose :
          @verbose = Defaults.verbose
      end
      attr_writer :verbose

      def previous_byte_offset
        @previous_byte_offset ||= 0
      end
      attr_writer :previous_byte_offset

      def enter_file(path)
        writer
          .text("Running #{path}")
          .newline

        self.previous_byte_offset = writer.byte_offset
      end

      def exit_file(_, _)
        if writer.byte_offset == previous_byte_offset
          writer
            .escape_code(:faint)
            .text("(Nothing written)")
            .escape_code(:reset_intensity)
            .newline
            .newline
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

      def skip_context(title)
        return if title.nil?

        writer
          .indent
          .escape_code(:yellow)
          .text(title)
          .escape_code(:reset_fg)
          .newline

        if writer.indentation_depth.zero?
          writer.newline
        end
      end

      def exit_context(title, result)
        return if title.nil?

        writer.decrease_indentation

        if verbose
          writer
            .indent
            .escape_code(:faint)
            .escape_code(:italic)
            .escape_code(result ? :green : :red)
            .text("Finished context #{title.inspect} (Result: #{self.class.result_text(result)})")
            .escape_code(:reset_fg)
            .escape_code(:reset_italic)
            .escape_code(:reset_intensity)
            .newline
        end

        if writer.indentation_depth.zero?
          writer.newline
        end
      end

      def start_test(title)
        if verbose
          title = title.nil? ? '(no title)' : title.inspect

          writer
            .indent
            .escape_code(:cyan)
            .text("Starting test #{title}")
            .escape_code(:reset_fg)
            .newline
        end

        writer.increase_indentation
      end

      def finish_test(title, result)
        writer.decrease_indentation

        if title.nil? && result
          return unless verbose
        end

        title ||= Defaults.test_title

        writer.indent

        if result
          writer.escape_code(:green)
        else
          writer
            .escape_code(:bold)
            .escape_code(:red)
        end

        writer.text(title)

        unless result
          writer.escape_code(:reset_intensity)
        end

        writer
          .escape_code(:reset_fg)
          .newline
      end

      def skip_test(title)
        title ||= Defaults.test_title

        skip_context(title)
      end

      def comment(text)
        writer
          .indent
          .text(text)
          .newline
      end

      def self.result_text(result)
        result ? 'pass' : 'failure'
      end

      module Defaults
        def self.test_title
          'Test'
        end

        def self.verbose
          false
        end
      end
    end
  end
end
