module TestBench
  class Run
    module Substitute
      def self.build
        Run.new
      end

      class Run
        attr_accessor :ran

        def paths
          @paths ||= []
        end

        def call(&block)
          self.ran = true

          block.(self) unless block.nil?
        end

        def path(path)
          paths << path
        end
        alias_method :<<, :path

        def ran?(*paths)
          return false unless ran

          paths.all? do |path|
            self.paths.include?(path)
          end
        end
      end
    end
  end
end
