module TestBench
  class Output
    class Timer
      module Substitute
        def self.build
          Timer.new
        end

        class Timer < Timer
          def mode
            @mode ||= Mode.stopped
          end
          attr_writer :mode

          def elapsed_time
            @elapsed_time ||= 0
          end
          attr_writer :elapsed_time
          alias_method :set, :elapsed_time=

          def start(_=nil)
            if mode == Mode.running
              raise Error, "Timer has already started"
            end

            self.mode = Mode.running
          end

          def stop(_=nil)
            if mode == Mode.stopped
              raise Error, "Timer has not started"
            end

            self.mode = Mode.stopped

            elapsed_time.round(3)
          end
        end
      end
    end
  end
end
