module TestBench
  module Controls
    module Stdin
      module Create
        def self.call(*paths)
          if paths.empty?
            paths = Path.examples
          end

          contents = <<~TEXT
          #{paths.join("\n")}
          TEXT

          file = File::Create.(contents:)

          ::File.open(file, 'r')
        end

        def self.contents
          <<~TEXT
          #{Path.example}
          TEXT
        end
      end
    end
  end
end
