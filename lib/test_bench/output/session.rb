module TestBench
  module Output
    class Session
      include Output

      def writer
        @writer ||= Writer::Substitute.build
      end
      attr_writer :writer

      def comment(text)
        writer
          .indent
          .text(text)
          .newline
      end

      module Defaults
        def self.verbose
          false
        end
      end
    end
  end
end
