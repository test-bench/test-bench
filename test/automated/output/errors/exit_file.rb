require_relative '../../automated_init'

context "Output" do
  context "Errors" do
    context "Exit File" do
      output = Output.new

      path = Controls::Path.example
      result = Controls::Result::Failure.example

      error = Controls::Error.example
      output.previous_error = error

      output.exit_file(path, result)

      test "Prints error, non-indented" do
        control_text = <<~TEXT
        #{error.backtrace[0]}: #{error.message} (#{error.class.name})
        \tfrom #{error.backtrace[1]}
        \tfrom #{error.backtrace[2]}
        TEXT

        pattern = Regexp.new(Regexp.escape(control_text))

        assert(output.writer.written?(pattern))
      end

      test "Resets previous error" do
        assert(output.previous_error.nil?)
      end
    end
  end
end
