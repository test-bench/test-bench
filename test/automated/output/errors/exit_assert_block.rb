require_relative '../../automated_init'

context "Output" do
  context "Errors" do
    context "Exit Assert Block" do
      output = Output.new

      result = Controls::Result::Failure.example

      error = Controls::Error.example
      output.previous_error = error

      output.assert_block_depth = Controls::Depth::Nested.example + 1

      output.exit_assert_block(result)

      test "Prints error, indented" do
        control_text = <<~TEXT
          #{error.backtrace[0]}: #{error.message} (#{error.class.name})
        \t  from #{error.backtrace[1]}
        \t  from #{error.backtrace[2]}
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
