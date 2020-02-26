require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Omit Backtrace Pattern" do
        writer = Output::Writer::Substitute.build

        omit_backtrace_pattern = Controls::CallerLocation::Alternate::Pattern.example

        backtrace = Controls::Error::Backtrace.example(depth: 11)
        error = Controls::Error.example(backtrace: backtrace)

        Output::PrintError.(
          error,
          writer: writer,
          reverse_backtraces: true,
          omit_backtrace_pattern: omit_backtrace_pattern
        )

        test "Matching backtrace frames are omitted" do
          assert(writer.written?(<<~TEXT))
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
        end
      end
    end
  end
end
