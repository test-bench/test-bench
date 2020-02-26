module TestBench
  module Controls
    module Time
      def self.example(seconds_offset: nil)
        seconds_offset ||= 0

        year = self.year
        month = self.month
        day = self.day

        hours = self.hours
        minutes = self.minutes
        seconds = self.seconds + seconds_offset

        if not RUBY_ENGINE == 'mruby'
          tz_offset = self.tz_offset

          final_argument = tz_offset
        else
          seconds, subseconds = seconds.divmod(1)

          microseconds = subseconds * 1_000_000

          final_argument = microseconds
        end

        ::Time.new(year, month, day, hours, minutes, seconds, final_argument)
      end

      def self.year
        2000
      end

      def self.month
        1
      end

      def self.day
        1
      end

      def self.hours
        11
      end

      def self.minutes
        11
      end

      def self.seconds
        11.0
      end

      def self.tz_offset
        0
      end

      module Elapsed
        def self.example
          1.111
        end

        module Text
          def self.example
            "1.111s"
          end
        end

        module PerSecond
          def self.example
            elapsed_time = Elapsed.example

            Rational(ocurrences, elapsed_time)
          end

          def self.ocurrences
            1
          end

          module Text
            def self.example
              "0.9"
            end
          end
        end
      end
    end
  end
end
