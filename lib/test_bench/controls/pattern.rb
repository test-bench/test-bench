module TestBench
  module Controls
    module Pattern
      def self.example
        /#{text}/
      end

      def self.text
        'some-pattern'
      end

      module None
        def self.example
          /#{text}/
        end

        def self.text
          '\z.'
        end
      end

      module Invalid
        def self.text
          '('
        end
      end
    end
  end
end
