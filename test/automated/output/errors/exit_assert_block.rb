require_relative '../../automated_init'

context "Output" do
  context "Errors" do
    context "Exit Assert Block" do
      output = Output.new

      caller_location = Controls::CallerLocation.example
      result = Controls::Result::Failure.example

      error = Controls::Error.example
      output.previous_error = error

      output.assert_block_depth = Controls::Depth::Nested.example + 1

      output.exit_assert_block(caller_location, result)

      test "Prints error" do
        control_text = <<~TEXT
        #{error.backtrace[0]}: #{error.message} (#{error.class.name})
        \tfrom #{error.backtrace[1]}
        \tfrom #{error.backtrace[2]}
        TEXT

        pattern = Regexp.new(Regexp.escape(control_text))

        assert(output.writer.written?(pattern))
      end

      context "Previous Error" do
        previous_error = output.previous_error

        test "Set to an assertion failure" do
          assert(previous_error.instance_of?(Fixture::AssertionFailure))
        end

        test "Backtrace set to caller location" do
          assert(previous_error.backtrace[0] == caller_location.to_s)
        end
      end
    end
  end
end
