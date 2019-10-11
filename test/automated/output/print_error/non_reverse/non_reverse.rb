require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      output = Output.new
      output.reverse_backtraces = false

      error = Controls::Error.example

      output.print_error(error)

      test "Writes error message to device" do
        control_text = <<~TEXT
        #{error.backtrace[0]}: #{error.message} (#{error.class.name})
        \tfrom #{error.backtrace[1]}
        \tfrom #{error.backtrace[2]}
        TEXT

        assert(output.writer.written?(control_text))
      end
    end
  end
end
