module TestBench
  class Run < Fixture::Run
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
