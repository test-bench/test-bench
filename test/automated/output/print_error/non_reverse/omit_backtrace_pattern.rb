require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Omit Backtrace Pattern" do
        output = Output.new
        output.reverse_backtraces = false

        output.omit_backtrace_pattern = Controls::CallerLocation::Alternate::Pattern.example

        backtrace = Controls::Error::Backtrace.example(depth: 11)

        error = Controls::Error.example(backtrace: backtrace)

        output.print_error(error)

        test "Matching backtrace frames are omitted" do
          control_text = <<~TEXT
          #{backtrace[0]}: #{error.message} (#{error.class.name})
          \t*omitted*
          \tfrom #{backtrace[3]}
          \t*omitted*
          \tfrom #{backtrace[6]}
          \t*omitted*
          \tfrom #{backtrace[9]}
          \t*omitted*
          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
