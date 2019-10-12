module TestBench
  class Run
    module Substitute
      def self.build
        Run.new
      end

      class Run < Fixture::Run::Substitute::Run
        def output
          @output ||= Output::Substitute.build
        end

        def start
          output.start_run
        end

        def started?
          output.recorded_once?(:start_run)
        end

        def finish
          result = !failed?

          output.finish_run(result)
        end

        def finished?(result=nil)
          if result.nil?
            output.recorded_once?(:finish_run)
          else
            output.recorded_once?(:finish_run) do |r|
              r == result
            end
          end
        end

        def load(path)
          output.enter_file(path)
        end

        def loaded?(path)
          output.recorded_once?(:enter_file) do |p|
            p == path
          end
        end
      end
    end
  end
end
