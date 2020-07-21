module TestBench
  module Controls
    module Output
      module BatchData
        def self.example(result: nil, depth: nil)
          result = self.result if result.nil?
          depth ||= self.depth

          TestBench::Output::BatchData.new(result, depth)
        end

        def self.result
          Pass.result
        end

        def self.depth
          1
        end

        module Pass
          def self.example(depth: nil)
            BatchData.example(result: result, depth: depth)
          end

          def self.result
            Result::Pass.example
          end
        end

        module Failure
          def self.example(depth: nil)
            BatchData.example(result: result, depth: depth)
          end

          def self.result
            Result::Failure.example
          end
        end

        module Toplevel
          def self.example(result: nil)
            BatchData.example(depth: depth, result: result)
          end

          def self.depth
            0
          end
        end
      end
    end
  end
end
