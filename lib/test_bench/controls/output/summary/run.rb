module TestBench
  module Controls
    module Output
      module Summary
        module Run
          def self.example(writer: nil, timer: nil)
            run_summary = Example.new
            run_summary.writer = writer unless writer.nil?
            run_summary.timer = timer unless timer.nil?
            run_summary
          end

          class Example
            include TestBench::Fixture::Output
            include TestBench::Output::Summary::Run

            TestBench::Fixture::Output.instance_methods.each do |method|
              define_method(method) do |*|
              end
            end
          end

          module Text
            def self.example
              <<~TEXT
              Finished running 0 files
              Ran 0 tests in 0.000s (0.0 tests/second)
              0 passed, 0 skipped, 0 failed, 0 total errors

              TEXT
            end

            module Pass
              def self.example
                <<~TEXT
                Finished running 1 file
                Ran 1 test in 0.000s (0.0 tests/second)
                1 passed, 0 skipped, 0 failed, 0 total errors

                TEXT
              end
            end

            module Failure
              def self.example
                <<~TEXT
                Finished running 1 file
                Ran 1 test in 0.000s (0.0 tests/second)
                0 passed, 0 skipped, 1 failed, 1 total error

                TEXT
              end
            end
          end
        end
      end
    end
  end
end
