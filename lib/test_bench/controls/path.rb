module TestBench
  module Controls
    module Path
      def self.example
        TestFile.filename
      end

      def self.alternate
        TestFile::Alternate.filename
      end

      Directory = Controls::Directory
    end
  end
end
