module TestBench
  module Output
    module Levels
      class None < Fixture::Output::Null
        def self.build
          warn "Warning: #{self} is deprecated. It will remain in the TestBench v2 series, but will be removed from TestBench v3"

          new
        end
      end
    end
  end
end
