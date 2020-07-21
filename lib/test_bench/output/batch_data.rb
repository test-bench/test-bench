module TestBench
  module Output
    BatchData = Struct.new(:result) do
      def passed?
        result
      end

      def failed?
        !result
      end
    end
  end
end
