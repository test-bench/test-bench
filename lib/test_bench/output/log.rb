module TestBench
  module Output
    module Log
      def self.build(device=nil, level: nil)
        level ||= Defaults.level

        Fixture::Output::Log.build(device, level: level)
      end

      def self.default_level
        :fatal
      end

      module Defaults
        def self.level
          level_text = ::ENV['TEST_BENCH_LOG_LEVEL']

          if level_text.nil?
            Log.default_level
          else
            level_text.to_sym
          end
        end
      end
    end
  end
end
