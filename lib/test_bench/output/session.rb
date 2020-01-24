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
        def self.verbose
          false
        end
      end
    end
  end
end
