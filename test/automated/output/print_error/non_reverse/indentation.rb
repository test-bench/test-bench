require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Indentation Depth" do
        output = Output.new
        output.reverse_backtraces = false

        output.writer.indentation_depth = 2

        error = Controls::Error.example

        output.print_error(error)

        test do
          control_text = <<~TEXT
              #{error.backtrace[0]}: #{error.message} (#{error.class.name})
          \t    from #{error.backtrace[1]}
          \t    from #{error.backtrace[2]}
          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
