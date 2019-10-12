module TestBench
  class Run < Fixture::Run
    def output
      @output ||= Output::Substitute.build
    end

    def load_context
      @load_context ||= self.class.fixture(self)
    end
    attr_writer :load_context

    attr_accessor :abort_on_error

    def self.build(output: nil, abort_on_error: nil)
      instance = new

      if output.nil?
        Output.configure(instance)
      else
        instance.output = output
      end

      instance.abort_on_error = abort_on_error unless abort_on_error.nil?

      error_policy = error_policy(abort_on_error)
      Fixture::ErrorPolicy.configure(instance, policy: error_policy)

      instance
    end

    def self.error_policy(abort_on_error=nil)
      abort_on_error = Defaults.abort_on_error if abort_on_error.nil?

      if abort_on_error
        :abort
      else
        :rescue
      end
    end

    def start
      output.start_run
    end

    def finish
      result = !failed?

      output.finish_run(result)
    end

    def load(path)
      output.enter_file(path)

      test_file_text = File.read(path)

      result = evaluate(->{
        load_context.instance_eval(test_file_text, path, 1)
      })

      output.exit_file(path, result)

      result
    end

    def abort_on_error?
      self.class.error_policy(self.abort_on_error) == :abort
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

    module Defaults
      def self.abort_on_error
        Environment::Boolean.fetch('TEST_BENCH_ABORT_ON_ERROR', false)
      end
    end
  end
end
