module TestBench
  module Output
    module Levels
      module Summary
        def self.build(timer: nil, **args)
          error_summary = Output::Summary::Error.build(**args)

          run_summary = Output::Summary::Run.build(writer: error_summary.writer)

          run_summary.timer = timer unless timer.nil?

          pass_output = Multiple.build(error_summary, run_summary)
          pass_output.extend(LevelPredicate)
          pass_output
        end

        def self.level
          :summary
        end

        module LevelPredicate
          def level?(level)
            level == Summary.level
          end
        end
      end
    end
  end
end
