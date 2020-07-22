require_relative '../../automated_init'

context "Output" do
  context "Timer" do
    context "Configure Receiver" do
      fixture(
        Fixtures::ConfigureReceiver,
        Output::Timer,
        attr_name: :timer
      )
    end
  end
end
