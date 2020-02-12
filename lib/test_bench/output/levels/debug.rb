module TestBench
  module Output
    module Levels
      module Debug
        def self.build(timer: nil, **args)
          session_output = Session.build(verbose: true, **args) 

          error_summary = Output::Summary::Error.build(writer: session_output.writer)

          run_summary = Output::Summary::Run.build(writer: session_output.writer)

          run_summary.timer = timer unless timer.nil?

          pass_output = Multiple.build(session_output, error_summary, run_summary)
          pass_output.extend(LevelPredicate)
          pass_output
        end

        def self.level
          :debug
        end

        module LevelPredicate
          def level?(level)
            level == Debug.level
          end
        end
      end
    end
  end
end
