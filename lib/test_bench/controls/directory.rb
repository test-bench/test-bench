module TestBench
  module Controls
    module Directory
      def self.example
        Dir.mktmpdir
      end

      module NonExistent
        def self.example
          "/tmp/#{SecureRandom.hex(7)}"
        end
      end
    end
  end
end
