module TestBench
  module Controls
    module Output
      module Styling
        def self.example
          detect
        end

        def self.detect
          :detect
        end

        def self.on
          :on
        end

        def self.off
          :off
        end

        module Invalid
          def self.example
            :not_a_styling_setting
          end
        end
      end
    end
  end
end
