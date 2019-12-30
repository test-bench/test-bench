require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Indentation Depth" do
        print_error = Output::PrintError.new
        print_error.reverse_backtraces = false

        print_error.writer.indentation_depth = 2

        error = Controls::Error.example

        print_error.(error)

        test do
          control_text = <<~TEXT
              #{error.backtrace[0]}: #{error.message} (#{error.class.name})
          \t    from #{error.backtrace[1]}
          \t    from #{error.backtrace[2]}
          TEXT

          assert(print_error.writer.written?(control_text))
        end
      end
    end
  end
end
