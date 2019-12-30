require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Error Cause" do
        print_error = Output::PrintError.new
        print_error.reverse_backtraces = false

        error_cause = Controls::Error::Cause.example
        error = Controls::Error.example(backtrace_depth: 5, cause: error_cause)

        print_error.(error)

        test do
          control_text = <<~TEXT
          #{error.backtrace[0]}: #{error.message} (#{error.class.name})
          \tfrom #{error.backtrace[1]}
          \tfrom #{error.backtrace[2]}
          \tfrom #{error.backtrace[3]}
          \tfrom #{error.backtrace[4]}
          #{error_cause.backtrace[0]}: #{error_cause.message} (#{error_cause.class.name})
          \tfrom #{error_cause.backtrace[1]}
          \tfrom #{error_cause.backtrace[2]}
          TEXT

          assert(print_error.writer.written?(control_text))
        end
      end
    end
  end
end
