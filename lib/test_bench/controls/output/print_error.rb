module TestBench
  module Controls
    module Output
      module PrintError
        def self.example(omit_backtrace_pattern: nil, reverse_backtraces: nil, writer: nil)
          print_error = Example.new
          print_error.omit_backtrace_pattern = omit_backtrace_pattern unless omit_backtrace_pattern.nil?
          print_error.reverse_backtraces = reverse_backtraces unless reverse_backtraces.nil?
          print_error.writer = writer unless writer.nil?
          print_error
        end

        class Example
          include TestBench::Output::PrintError
        end
      end
    end
  end
end
