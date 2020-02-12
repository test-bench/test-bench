require_relative '../automated_init'

context "Output" do
  context "Configure Receiver" do
    context "Accepts Arguments" do
      arg1 = 'some-value'
      arg2 = 'other-value'

      fixture(
        Fixtures::ConfigureReceiver,
        Controls::Output::ConfigureArguments::Example,
        attr_name: :output,
        arg1: arg1,
        arg2: arg2
      )
    end

    context "Does Not Accept Any Arguments" do
      fixture(
        Fixtures::ConfigureReceiver,
        Controls::Output::ConfigureArguments::None::Example,
        attr_name: :output
      )
    end
  end
end
