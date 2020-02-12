module TestBench
  module Output
    module Build
      Error = Class.new(RuntimeError)

      def self.call(level: nil, omit_backtrace_pattern: nil, reverse_backtraces: nil, writer: nil, styling: nil, device: nil)
        level ||= Defaults.level

        assure_level(level)

        case level
        when Levels::None.level
          Levels::None.new
        when Levels::Summary.level
          Levels::Summary.build(writer: writer, styling: styling, device: device)
        when Levels::Failure.level
          Levels::Failure.build(omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, styling: styling, device: device)
        when Levels::Pass.level
          Levels::Pass.build(omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, styling: styling, device: device)
        when Levels::Debug.level
          Levels::Debug.build(omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, styling: styling, device: device)
        end
      end

      def self.assure_level(level)
        unless levels.include?(level)
          raise Error, "Unknown level #{level.inspect} (Levels: #{levels.map(&:inspect) * ', '})"
        end
      end

      def self.levels
        [
          Levels::None.level,
          Levels::Summary.level,
          Levels::Failure.level,
          Levels::Pass.level,
          Levels::Debug.level
        ]
      end

      module Defaults
        def self.level
          level = ::ENV['TEST_BENCH_OUTPUT_LEVEL']

          if level.nil?
            Levels::Pass.level
          else
            level.to_sym
          end
        end
      end
    end
  end
end
