require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Omit Backtrace Pattern" do
        writer = Output::Writer::Substitute.build

        omit_backtrace_pattern = Regexp.new(Controls::CallerLocation::Alternate.file)

        backtrace = Controls::Error::Backtrace.example(depth: 11)
        error = Controls::Error.example(backtrace: backtrace)

        Output::PrintError.(
          error,
          writer: writer,
          reverse_backtraces: false,
          omit_backtrace_pattern: omit_backtrace_pattern
        )

        test "Matching backtrace frames are omitted" do
          assert(writer.written?(<<TEXT))
#{backtrace[0]}: #{error.message} (#{error.class.name})
\t*omitted*
\tfrom #{backtrace[3]}
\t*omitted*
\tfrom #{backtrace[6]}
\t*omitted*
\tfrom #{backtrace[9]}
\t*omitted*
TEXT
        end
      end
    end
  end
end
