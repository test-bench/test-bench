require_relative '../../automated_init'

context "Fixtures" do
  context "Configure Receiver" do
    context "Additional Arguments" do
      context "Positional" do
        cls = Struct.new(:arg1, :arg2) do
          def self.configure(receiver, arg1, arg2=nil, attr_name: nil)
            attr_name ||= :some_attr

            instance = new(arg1, arg2)
            receiver.public_send(:"#{attr_name}=", instance)
            instance
          end
        end

        fixture(
          Fixtures::ConfigureReceiver,
          cls,
          'some-value',
          'other-value',
          attr_name: :some_attr
        )
      end

      context "Keyword" do
        cls = Struct.new(:arg1, :arg2) do
          def self.configure(receiver, arg1:, arg2: nil, attr_name: nil)
            attr_name ||= :some_attr

            instance = new(arg1, arg2)
            receiver.public_send(:"#{attr_name}=", instance)
            instance
          end
        end

        fixture(
          Fixtures::ConfigureReceiver,
          cls,
          arg1: 'some-value',
          arg2: 'other-value',
          attr_name: :some_attr
        )
      end

      context "Positional And Keyword" do
        cls = Struct.new(:arg1, :arg2) do
          def self.configure(receiver, arg1, arg2:, attr_name: nil)
            attr_name ||= :some_attr

            instance = new(arg1, arg2)
            receiver.public_send(:"#{attr_name}=", instance)
            instance
          end
        end

        fixture(
          Fixtures::ConfigureReceiver,
          cls,
          'some-value',
          arg2: 'other-value',
          attr_name: :some_attr
        )
      end
    end
  end
end
