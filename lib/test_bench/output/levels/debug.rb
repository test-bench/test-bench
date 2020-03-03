module TestBench
  module Output
    module Levels
      class Debug
        include TestBench::Fixture::Output

        include Writer::Dependency

        def comment(text)
          writer
            .indent
            .text(text)
            .newline
        end
      end
    end
  end
end
