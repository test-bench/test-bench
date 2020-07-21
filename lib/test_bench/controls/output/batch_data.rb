module TestBench
  module Controls
    module Output
      module BatchData
        def self.example(result: nil)
          result = self.result if result.nil?

          TestBench::Output::BatchData.new(result)
        end

        def self.result
          Pass.result
        end

        module Pass
          def self.example
            BatchData.example(result: result)
          end

          def self.result
            Result::Pass.example
          end
        end

        module Failure
          def self.example
            BatchData.example(result: result)
          end

          def self.result
            Result::Failure.example
          end
        end
      end
    end
  end
end
