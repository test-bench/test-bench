module TestBench
  module Output
    module Levels
      class None < Fixture::Output::Null
        def self.level
          :none
        end

        def level?(level)
          level == self.class.level
        end
      end
    end
  end
end
