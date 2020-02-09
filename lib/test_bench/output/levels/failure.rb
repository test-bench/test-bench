module TestBench
  module Output
    module Levels
      module Failure
        def self.build(**args)
          session_output = Session.build(**args) 

          error_summary = Output::Summary::Error.build(writer: session_output.writer)

          failure_output = Multiple.build(session_output, error_summary)
          failure_output.extend(LevelPredicate)
          failure_output
        end

        def self.level
          :failure
        end

        module LevelPredicate
          def level?(level)
            level == Failure.level
          end
        end

        class Session
          include TestBench::Output

          def writer
            @writer ||= Writer.new
          end
          attr_writer :writer

          def print_error
            @print_error ||= PrintError.new
          end
          attr_writer :print_error

          def configure(omit_backtrace_pattern: nil, reverse_backtraces: nil, writer: nil, styling: nil, device: nil)
            writer = Writer.configure(self, writer: writer, styling: styling, device: device)

            print_error.configure(omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer)
          end

          def error(error)
            print_error.(error)

            writer.newline
          end
        end
      end
    end
  end
end
