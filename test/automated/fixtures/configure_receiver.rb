require_relative '../automated_init'

context "Fixtures" do
  context "Configure Receiver" do
    cls = Class.new do
      def self.configure(receiver, attr_name: nil)
        attr_name ||= :some_attr

        instance = new
        receiver.public_send(:"#{attr_name}=", instance)
        instance
      end
    end

    fixture(Fixtures::ConfigureReceiver, cls, attr_name: :some_attr)
  end
end
