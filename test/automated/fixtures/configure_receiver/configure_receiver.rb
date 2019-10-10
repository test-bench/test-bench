require_relative '../../automated_init'

context "Fixtures" do
  context "Configure Receiver" do
    context "Pass" do
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

    context "Failure" do
      context "No Configure Method" do
        cls = Object.new

        fixture = Fixtures::ConfigureReceiver.new(cls, :some_attr)

        fixture.()

        test do
          assert(fixture.test_run.failed?)
        end
      end

      context "Does not configure receiver" do
        cls = Class.new do
          def self.configure(receiver, attr_name: nil)
          end
        end

        fixture = Fixtures::ConfigureReceiver.new(cls, :some_attr)

        fixture.()

        test do
          assert(fixture.test_run.failed?)
        end
      end
    end
  end
end
