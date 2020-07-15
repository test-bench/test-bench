module TestBench
  module Output
    class Raw
      Error = Class.new(RuntimeError)

      include Fixture::Output
      include Writer::Dependency

      include PrintError

      def verbose
        instance_variable_defined?(:@verbose) ?
          @verbose :
          @verbose = Defaults.verbose
      end
      attr_writer :verbose
      alias_method :verbose?, :verbose

      def detail_setting
        @detail_setting ||= Defaults.detail
      end
      attr_writer :detail_setting

      attr_accessor :current_batch

      def batch_starting(batch_data)
        if batch_data.depth.zero?
          self.current_batch = batch_data
        end
      end

      def batch_finished(batch_data)
        if batch_data.depth.zero?
          self.current_batch = nil
        end
      end

      def detail?(result=nil)
        result ||= current_batch&.result

        case detail_setting
        when :failure
          result != true
        when :on
          true
        when :off
          false
        end
      end

      def enter_context(title, batch_data: nil)
        batch_starting(batch_data) unless batch_data.nil?

        return if title.nil?

        writer
          .indent
          .escape_code(:green)
          .text(title)
          .escape_code(:reset_fg)
          .newline

        writer.increase_indentation
      end

      def exit_context(title, result, batch_data: nil)
        return if title.nil?

        writer.decrease_indentation

        if verbose?
          text = "Finished context #{title.inspect} (Result: #{result_text(result)})"

          color = result ? :green : :red

          writer
            .indent
            .escape_code(:faint).escape_code(:italic).escape_code(color)
            .text(text)
            .escape_code(:reset_fg).escape_code(:reset_italic).escape_code(:reset_intensity)
            .newline
        end

        if writer.indentation_depth.zero?
          writer.newline
        end

      ensure
        batch_finished(batch_data) unless batch_data.nil?
      end

      def skip_context(title)
        return if title.nil?

        writer
          .indent
          .escape_code(:yellow)
          .text(title)
          .escape_code(:reset_fg)
          .newline
      end

      def start_test(title, batch_data: nil)
        batch_starting(batch_data) unless batch_data.nil?

        batch_data = nil if verbose

        if batch_data&.passed? && title.nil?
          return
        end

        if batch_data.nil?
          if title.nil?
            text = "Starting test"
          else
            text = "Starting test #{title.inspect}"
          end

          writer
            .indent
            .escape_code(:faint)
            .escape_code(:italic)
            .escape_code(:blue)
            .text(text)
            .escape_code(:reset_fg)
            .escape_code(:reset_italic)
            .escape_code(:reset_intensity)
            .newline

        else
          result = batch_data.result

          print_test_result(title, result)
        end

        writer.increase_indentation
      end

      def finish_test(title, result, batch_data: nil)
        batch_data = nil if verbose?

        if batch_data&.passed? && title.nil?
          return
        end

        writer.decrease_indentation

        if batch_data.nil?
          print_test_result(title, result)
        end

      ensure
        batch_finished(batch_data) unless batch_data.nil?
      end

      def print_test_result(title, result)
        title ||= default_test_title

        if writer.styling?
          text = title
        elsif result
          text = title
        else
          text = "#{title} (failed)"
        end

        color = result ? :green : :red

        writer
          .indent
          .escape_code(color)
          .text(text)
          .escape_code(:reset_fg)
          .newline
      end

      def skip_test(title)
        title ||= default_test_title

        if writer.styling?
          text = title
        else
          text = "#{title} (skipped)"
        end

        writer
          .indent
          .escape_code(:yellow)
          .text(text)
          .escape_code(:reset_fg)
          .newline
      end

      def error(error)
        print_error(error)
      end

      def comment(text)
        writer
          .indent
          .text(text)
          .newline
      end

      def detail(text)
        return unless verbose? || detail?

        if verbose? && !detail?
          text = "(detail omitted: #{text})"
        end

        writer
          .indent
          .text(text)
          .newline
      end

      def result_text(result)
        result ? 'pass' : 'failure'
      end

      def default_test_title
        'Test'
      end

      def self.assure_detail_setting(detail_setting)
        unless detail_settings.include?(detail_setting)
          raise Error, "Invalid detail setting #{detail_setting.inspect} (Valid values: #{detail_settings.map(&:inspect).join(', ')})"
        end
      end

      def self.detail_settings
        [
          :failure,
          :on,
          :off
        ]
      end

      def self.default_detail_setting
        detail_settings.fetch(0)
      end

      module Defaults
        def self.verbose
          Environment::Boolean.fetch('TEST_BENCH_VERBOSE', false)
        end

        def self.detail
          detail = ::ENV['TEST_BENCH_DETAIL']

          if detail.nil?
            Raw.default_detail_setting
          else
            detail.to_sym
          end
        end
      end
    end
  end
end
