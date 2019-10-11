module TestBench
  class Output
    module Substitute
      def self.build
        Output.new
      end

      class Output < Fixture::Output::Substitute::Output
        def enter_file(path)
          record(:enter_file, path)
        end

        def exit_file(path, result)
          record(:exit_file, path, result)
        end

        def start_run
          record(:start_run)
        end

        def finish_run(result)
          record(:finish_run, result)
        end
      end
    end
  end
end
