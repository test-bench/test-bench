module TestBench
  module Controls
    module Device
      def self.example
        Interactive.example
      end

      module Interactive
        def self.example
          device = Non.example

          def device.tty?
            true
          end

          device
        end

        module Non
          def self.example
            StringIO.new
          end
        end
      end
    end
  end
end
