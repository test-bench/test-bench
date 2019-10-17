module TestBench
  module Controls
    module Output
      module NewlineCharacter
        def self.example
          StringIO.new.tap(&:puts).string
        end
      end
    end
  end
end
