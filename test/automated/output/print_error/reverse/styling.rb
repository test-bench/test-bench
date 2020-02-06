require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Styling" do
        print_error = Output::PrintError.new
        print_error.reverse_backtraces = true

        print_error.omit_backtrace_pattern = Controls::CallerLocation::Alternate::Pattern.example

        print_error.writer.enable_styling!

        error = Controls::Error.example

        print_error.(error)

        test do
          control_text = <<~TEXT.chomp
          \e[31m\e[1mTraceback\e[22m (most recent call last):
          \t?: \e[2;3m*omitted*\e[23;22m
          #{error.backtrace[0]}: \e[1m#{error.message} (\e[4m#{error.class.name}\e[24m)\e[22m
          \e[39m
          TEXT

          assert(print_error.writer.written?(control_text))
        end
      end
    end
  end
end
