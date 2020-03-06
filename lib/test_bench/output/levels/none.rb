module TestBench
  module Output
    module Levels
      class None < Fixture::Output::Null
        def self.build
          new
        end
      end
    end
  end
end
