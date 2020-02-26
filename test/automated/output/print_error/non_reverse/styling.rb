require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Styling" do
        writer = Output::Writer::Substitute.build
        writer.enable_styling!

        omit_backtrace_pattern = Controls::CallerLocation::Alternate::Pattern.example

        error = Controls::Error.example

        Output::PrintError.(
          error,
          writer: writer,
          reverse_backtraces: false,
          omit_backtrace_pattern: omit_backtrace_pattern
        )

        test do
          assert(writer.written?(<<~TEXT.chomp))
            \e[31m#{error.backtrace[0]}: \e[1m#{error.message} (\e[4m#{error.class.name}\e[24m)\e[22m
            \t\e[2;3m*omitted*\e[23;22m
            \e[39m
          TEXT
        end
      end
    end
  end
end
