module TestBench
  class Output
    class Writer
      module Substitute
        def self.build
          Writer.new
        end

        class Writer < Writer
          def written?(pattern=nil)
            pattern = self.pattern(pattern)

            written_text = device.string

            pattern.match?(written_text)
          end

          def pattern(pattern)
            case pattern
            when nil
              /./
            when String
              Regexp.new("\\A#{Regexp.escape(pattern)}\\z")
            else
              pattern
            end
          end
        end
      end
    end
  end
end
