module TestBench
  module Output
    class Writer
      module Dependency
        def writer
          @writer ||= Substitute.build
        end
        attr_writer :writer
      end
    end
  end
end
