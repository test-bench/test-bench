require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Indentation Depth" do
        print_error = Output::PrintError.new
        print_error.reverse_backtraces = true

        print_error.writer.indentation_depth = 2

        error = Controls::Error.example

        print_error.(error)

        test do
          control_text = <<~TEXT
              Traceback (most recent call last):
          \t    2: from #{error.backtrace[2]}
          \t    1: from #{error.backtrace[1]}
              #{error.backtrace[0]}: #{error.message} (#{error.class.name})
          TEXT

          assert(print_error.writer.written?(control_text))
        end
      end
    end
  end
end
