require_relative '../automated_init'

context "Output" do
  context "Configure Receiver" do
    fixture(
      Fixtures::ConfigureReceiver,
      Output,
      attr_name: :output
    )
  end
end
