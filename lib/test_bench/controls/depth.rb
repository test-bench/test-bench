module TestBench
  module Controls
    module Depth
      def self.example
        Nested.example
      end

      module Nested
        def self.example
          2
        end
      end

      module Outermost
        def self.example
          0
        end
      end
    end
  end
end
