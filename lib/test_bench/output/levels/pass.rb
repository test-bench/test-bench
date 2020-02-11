module TestBench
  module Output
    module Levels
      module Pass
        def self.build(timer: nil, **args)
          session_output = Session.build(verbose: false, **args) 

          error_summary = Output::Summary::Error.build(writer: session_output.writer)

          run_summary = Output::Summary::Run.build(writer: session_output.writer)

          run_summary.timer = timer unless timer.nil?

          pass_output = Multiple.build(session_output, error_summary, run_summary)
          pass_output.extend(LevelPredicate)
          pass_output
        end

        def self.level
          :pass
        end

        module LevelPredicate
          def level?(level)
            level == Pass.level
          end
        end
      end
    end
  end
end
