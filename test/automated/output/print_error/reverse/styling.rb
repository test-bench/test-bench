require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Styling" do
        output = Output.new
        output.reverse_backtraces = true

        output.omit_backtrace_pattern = Controls::CallerLocation::Alternate::Pattern.example

        output.writer.enable_styling!

        error = Controls::Error.example

        output.print_error(error)

        test do
          control_text = <<~TEXT.chomp
          \e[31m\e[1mTraceback\e[22m (most recent call last):
          \t?: \e[2;3m*omitted*\e[23;22m
          #{error.backtrace[0]}: \e[1m#{error.message} (\e[4m#{error.class.name}\e[24m)\e[22m
          \e[39m
          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end