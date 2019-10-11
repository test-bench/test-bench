require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Omit Backtrace Pattern" do
        output = Output.new
        output.reverse_backtraces = true

        output.omit_backtrace_pattern = Controls::CallerLocation::Alternate::Pattern.example

        backtrace = Controls::Error::Backtrace.example(depth: 11)

        error = Controls::Error.example(backtrace: backtrace)

        output.print_error(error)

        test "Matching backtrace frames are omitted" do
          control_text = <<~TEXT
          Traceback (most recent call last):
          \t??: *omitted*
          \t 9: from #{backtrace[9]}
          \t ?: *omitted*
          \t 6: from #{backtrace[6]}
          \t ?: *omitted*
          \t 3: from #{backtrace[3]}
          \t ?: *omitted*
          #{backtrace[0]}: #{error.message} (#{error.class.name})
          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
