module TestBench
  module Output
    module Build
      Error = Class.new(RuntimeError)

      def self.call(level: nil, **args)
        level ||= Defaults.level

        level_setting = level

        cls = level_class(level_setting)

        cls.build(**args)
      end

      def self.level_class(level_setting)
        assure_level(level_setting)

        levels.fetch(level_setting)
      end

      def self.levels
        {
          :none => Levels::None,
          :summary => Levels::Summary,
          :failure => Levels::Failure,
          :pass => Levels::Pass,
          :debug => Levels::Debug
        }
      end

      def self.level_settings
        levels.keys
      end

      def self.assure_level(level_setting)
        unless level_settings.include?(level_setting)
          raise Error, "Unknown output level #{level_setting.inspect} (Valid levels: #{level_settings.map(&:inspect) * ', '})"
        end
      end

      module Defaults
        def self.level
          level_text = ENV.fetch('TEST_BENCH_OUTPUT_LEVEL', 'pass')

          level_text.to_sym
        end
      end
    end
  end
end
