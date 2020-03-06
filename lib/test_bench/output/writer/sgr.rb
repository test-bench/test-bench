module TestBench
  module Output
    class Writer
      module SGR
        def self.escape_code(name)
          assure_escape_code(name)

          code_map.fetch(name)
        end

        def self.assure_escape_code(name)
          unless code_map.key?(name)
            raise Error, "Invalid escape code #{name.inspect} (Example values: #{code_map.keys.first(3).map(&:inspect).join(', ')})"
          end
        end

        def self.code_map
          @code_map ||= {
            :reset => '0',

            :bold => '1',
            :faint => '2',
            :italic => '3',
            :underline => '4',

            :reset_intensity => '22',
            :reset_italic => '23',
            :reset_underline => '24',

            :black => '30',
            :red => '31',
            :green => '32',
            :yellow => '33',
            :blue => '34',
            :magenta => '35',
            :cyan => '36',
            :white => '37',
            :reset_fg => '39',

            :black_bg => '40',
            :red_bg => '41',
            :green_bg => '42',
            :yellow_bg => '43',
            :blue_bg => '44',
            :magenta_bg => '45',
            :cyan_bg => '46',
            :white_bg => '47',
            :reset_bg => '49'
          }
        end
      end
    end
  end
end
