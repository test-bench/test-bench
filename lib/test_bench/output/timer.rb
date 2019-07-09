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

      def running?
        mode == Mode.running
      end

      def mode
        if start_time.nil?
          Mode.stopped
        else
          Mode.running
        end
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
