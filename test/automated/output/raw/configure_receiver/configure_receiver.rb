require_relative '../../../automated_init'

context "Raw Output" do
  context "Configure Receiver" do
    fixture(
      Fixtures::ConfigureReceiver,
      Output::Raw,
      attr_name: :raw_output
    )
  end
end
