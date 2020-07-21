module TestBench
  module Output
    BatchData = Struct.new(:result, :depth) do
      def passed?
        result
      end

      def failed?
        !result
      end

      def toplevel?
        depth.zero?
      end
    end
  end
end
