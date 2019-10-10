require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Configure Receiver" do
      fixture(
        Fixtures::ConfigureReceiver,
        Output::Writer,
        attr_name: :writer
      )
    end
  end
end
