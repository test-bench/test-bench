require_relative '../../automated_init'

context "Runner" do
  context "Configure Receiver" do
    fixture(Fixtures::ConfigureReceiver, Run, attr_name: :run)
  end
end
