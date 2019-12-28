module TestBench
  module Output
    class Multiple
      include Output

      def outputs
        @outputs ||= []
      end
      attr_writer :outputs

      def self.build(*outputs)
        outputs = Array(outputs)

        instance = new

        outputs.each do |output|
          instance.register(output)
        end

        instance
      end

      Fixture::Output.instance_methods.each do |method_name|
        define_method(method_name) do |*args|
          outputs.map do |output|
            output.public_send(method_name, *args)
          end
        end
      end

      def register(output)
        outputs << output
      end

      def registered?(output)
        outputs.include?(output)
      end
    end
  end
end
