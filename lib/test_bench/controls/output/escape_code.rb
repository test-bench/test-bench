module TestBench
  module Controls
    module Output
      module EscapeCode
        def self.example
          '1'
        end

        module ID
          def self.example
            :bold
          end

          module Unknown
            def self.example
              :unknown
            end
          end
        end
      end
    end
  end
end
