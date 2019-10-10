require_relative '../../automated_init'

context "Output" do
  context "Errors" do
    context "Exit Context" do
      output = Output.new

      output.writer.indentation_depth = 1

      result = Controls::Result::Failure.example

      error = Controls::Error.example
      output.previous_error = error

      output.exit_context("Some Context", result)

      test "Prints error, indented" do
        control_text = <<~TEXT
          #{error.backtrace[0]}: #{error.message} (#{error.class.name})
        \t  from #{error.backtrace[1]}
        \t  from #{error.backtrace[2]}
        TEXT

        pattern = Regexp.new(Regexp.escape(control_text))

        assert(output.writer.written?(pattern))
      end

      test "Resets writer indentation depth" do
        refute(output.writer.indentation_depth > 1)
      end

      test "Resets previous error" do
        assert(output.previous_error.nil?)
      end
    end
  end
end
