module TestBench
  module Controls
    module Output
      def self.example(&block)
        if block.nil?
          cls = Example
        else
          cls = example_class(&block)
        end

        cls.new
      end

      def self.example_class(&block)
        Class.new do
          include TestBench::Output

          class_exec(&block) unless block.nil?
        end
      end

      Example = example_class

      module Exercise
        def self.call(output=nil, &block)
          output ||= Output.example

          TestBench::Fixture::Controls::Output::Exercise.call(output, &block)
        end

        def self.each_method(*args, &block)
          TestBench::Fixture::Controls::Output::Exercise.each_method(*args, &block)
        end
      end

      module ConfigureArguments
        def self.example
          Example.new
        end

        Example = Output.example_class do
          attr_accessor :arg1, :arg2

          def configure(arg1: nil, arg2: nil)
            self.arg1 = arg1
            self.arg2 = arg2
          end
        end

        module None
          def self.example
            Output.example
          end

          Example = Output.example_class do
            def configure
            end
          end
        end
      end
    end
  end
end
