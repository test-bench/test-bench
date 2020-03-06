module TestBench
  module Output
    module Levels
      class Failure
        include TestBench::Fixture::Output

        include Output::PrintError
        include Output::Summary::Error

        def self.build(omit_backtrace_pattern: nil, reverse_backtraces: nil, writer: nil, styling: nil, device: nil)
          warn "Warning: #{self} is deprecated. It will remain in the TestBench v2 series, but will be removed from TestBench v3"

          instance = new

          instance.omit_backtrace_pattern = omit_backtrace_pattern unless omit_backtrace_pattern.nil?
          instance.reverse_backtraces = reverse_backtraces unless reverse_backtraces.nil?

          Writer.configure(instance, writer: writer, styling: styling, device: device)

          instance
        end

        def error(error)
          print_error(error)

          writer.newline
        end
      end
    end
  end
end
