require_relative '../automated_init'

context "Output" do
  context "Substitute" do
    substitute = Output::Substitute.build

    result = Controls::Result.example
    caller_location = Controls::CallerLocation.example
    error = Controls::Error.example
    path = Controls::Path.example

    {
      :assert => [result, caller_location],
      :enter_assert_block => [],
      :exit_assert_block => [result],
      :comment => ["Some text"],
      :error => [error],
      :start_test => ["Some test"],
      :finish_test => ["Some test", result],
      :skip_test => ["Some test"],
      :enter_context => ["Some Context"],
      :exit_context => ["Some Context", result],
      :skip_context => ["Some Context"],
      :enter_file => [path],
      :exit_file => [path, result],
      :start_run => [],
      :finish_run => [result]
    }.each do |method_name, arguments|
      context "Method: #{method_name}" do
        substitute.public_send(method_name, *arguments)

        test "Records method invocation" do
          recorded_invocation = substitute.records.one? do |record|
            record.signal == method_name && record.data == arguments
          end

          assert(recorded_invocation)
        end
      end
    end
  end
end
