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
