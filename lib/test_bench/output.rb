module TestBench
  module Output
    def self.included(cls)
      cls.class_exec do
        include TestBench::Fixture::Output

        extend Build
        extend Configure
      end
    end

    def configure
    end

    Substitute = TestBench::Fixture::Output::Substitute

    module Build
      def build(**args)
        instance = new
        instance.configure(**args)
        instance
      end
    end

    module Configure
      def configure(receiver, attr_name: nil, **args)
        attr_name ||= :output

        instance = build(**args)
        receiver.public_send(:"#{attr_name}=", instance)
        instance
      end
    end
  end
end
