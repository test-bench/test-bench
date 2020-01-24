module TestBench
  module Output
    class Multiple
      include Output

      def outputs
        @outputs ||= []
      end
      attr_writer :outputs

      def register(output)
        outputs << output
      end

      def registered?(output)
        outputs.include?(output)
      end
    end
  end
end
