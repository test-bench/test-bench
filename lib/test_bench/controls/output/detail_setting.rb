module TestBench
  module Controls
    module Output
      module DetailSetting
        def self.example
          failure
        end

        def self.failure
          :failure
        end

        def self.on
          :on
        end

        def self.off
          :off
        end

        module Invalid
          def self.example
            :not_a_detail_setting
          end
        end
      end
    end
  end
end
