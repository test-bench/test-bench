require_relative '../automated_init'

context "Run" do
  context "Configure Receiver" do
    output = Output.new

    abort_on_error = true

    load_context = Object.new

    fixture(
      Fixtures::ConfigureReceiver,
      Run,
      output: output,
      abort_on_error: abort_on_error,
      load_context: load_context,
      attr_name: :test_run
    )
  end
end
