module TestBench
  class Output
    class Timer
      Error = Class.new(RuntimeError)

      attr_accessor :start_time

      def start(now=nil)
        now ||= ::Time.now.utc

        if mode == Mode.running
          raise Error, "Timer has already started (Start Time: #{start_time})"
        end

        self.start_time = now
      end

      def stop(now=nil)
        now ||= ::Time.now.utc

        if mode == Mode.stopped
          raise Error, "Timer has not started"
        end

        start_time = reset

        elapsed = now - start_time

        elapsed.round(3)
      end

      def running?
        mode == Mode.running
      end

      def stopped?
        mode == Mode.stopped
      end

      def mode
        if start_time.nil?
          Mode.stopped
        else
          Mode.running
        end
      end

      def reset
        previous_start_time = self.start_time

        self.start_time = nil

        previous_start_time
      end

      module Mode
        def self.running
          :running
        end

        def self.stopped
          :stopped
        end
      end
    end
  end
end
