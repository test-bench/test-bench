module TestBench
  module Output
    class Session
      include Output

      def writer
        @writer ||= Writer::Substitute.build
      end
      attr_writer :writer

      def print_error
        @print_error ||= PrintError.new
      end
      attr_writer :print_error

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

      attr_accessor :previous_error

      def enter_file(path)
        writer
          .text("Running #{path}")
          .newline

        self.previous_byte_offset = writer.byte_offset
      end

      def exit_file(path, result)
        unless result || previous_error.nil?
          print_previous_error!

          writer.newline
        end

        if writer.byte_offset == previous_byte_offset
          writer
            .escape_code(:faint)
            .text("(Nothing written)")
            .escape_code(:reset_intensity)
            .newline
            .newline
        end
      end

      def start_fixture(fixture)
        if verbose
          writer
            .indent
            .escape_code(:cyan)
            .text("Starting fixture (Fixture: #{fixture.class.inspect})")
            .escape_code(:reset_fg)
            .newline

          writer.increase_indentation
        end
      end

      def finish_fixture(fixture, result)
        unless result || previous_error.nil?
          print_previous_error!
        end

        if verbose
          writer
            .indent
            .escape_code(:magenta)
            .text("Finished fixture (Fixture: #{fixture.class.inspect}, Result: #{self.class.result_text(result)})")
            .escape_code(:reset_fg)
            .newline

          writer.decrease_indentation

          if writer.indentation_depth.zero?
            writer.newline
          end
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
        if title.nil?
          print_previous_error! unless previous_error.nil?
          return
        end

        writer.decrease_indentation

        unless result || previous_error.nil?
          print_previous_error
        end

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

        unless result || previous_error.nil?
          print_previous_error
        end
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

      def error(error)
        self.previous_error = error
      end

      def print_previous_error
        writer.increase_indentation

        print_previous_error!

        writer.decrease_indentation
      end

      def print_previous_error!
        print_error.(previous_error)

        self.previous_error = nil
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
