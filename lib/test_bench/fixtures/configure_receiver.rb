module TestBench
  module Fixtures
    class ConfigureReceiver
      include TestBench::Fixture

      attr_reader :cls
      attr_reader :default_attr_name

      def args
        @args ||= []
      end

      def kwargs
        @kwargs ||= {}
      end

      def initialize(cls, default_attr_name, args=nil, kwargs=nil)
        @cls = cls
        @default_attr_name = default_attr_name
        @args = args
        @kwargs = kwargs
      end

      def self.build(cls, *args, attr_name:, **kwargs)
        new(cls, attr_name, args, kwargs)
      end

      def call
        test "Responds to configure" do
          assert(cls.respond_to?(:configure))
        end or return

        context do
          receiver = OpenStruct.new

          instance = configure(receiver)

          test "Attribute is set on receiver" do
            refute(receiver.public_send(default_attr_name).nil?)
          end

          test "Returns the instance that was assigned" do
            assert(receiver.public_send(default_attr_name).equal?(instance))
          end
        end

        context "Optional Attribute Name" do
          context "Given" do
            receiver = OpenStruct.new
            attr_name = :given_attr_name

            configure(receiver, attr_name: attr_name)

            test "Given attribute is set on receiver (Attribute: #{attr_name})" do
              refute(receiver.public_send(attr_name).nil?)
            end

            test "Default attribute is not set on receiver" do
              assert(receiver.public_send(default_attr_name).nil?)
            end
          end

          context "Omitted" do
            receiver = OpenStruct.new

            configure(receiver)

            test "Default attribute is set on receiver (Attribute: #{default_attr_name})" do
              refute(receiver.public_send(default_attr_name).nil?)
            end
          end
        end
      end

      def configure(receiver, attr_name: nil)
        cls.configure(receiver, *args, attr_name: attr_name, **kwargs)
      end
    end
  end
end
