module TestBench
  module Controls
    module Output
      module Summary
        module Error
          module Text
            def self.example
              <<TEXT
Error Summary:
   1: #{file}
      #{error.backtrace[0]}: #{error} (#{error.class})

TEXT
            end

            def self.file
              TestFile.filename
            end

            def self.error
              Controls::Error.example
            end
          end
        end
      end
    end
  end
end
