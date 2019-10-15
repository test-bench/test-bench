module TestBench
  class Run < Fixture::Run
    def output
      @output ||= Output::Substitute.build
    end

    def load_context
      @load_context ||= self.class.fixture(self)
    end
    attr_writer :load_context

    def load(path)
      output.enter_file(path)

      test_file_text = File.read(path)

      result = evaluate(->{
        load_context.instance_eval(test_file_text, path, 1)
      })

      output.exit_file(path, result)

      result
    end

    def self.fixture(instance, receiver=nil)
      receiver ||= Object.new

      receiver.extend(Fixture)
      receiver.extend(Fixture::UnderscoreVariants)
      receiver.test_run = instance
      receiver
    end

    module Fixture::UnderscoreVariants
      def _context(*args)
        context(*args)
      end

      def _test(*args)
        test(*args)
      end
    end
  end
end
