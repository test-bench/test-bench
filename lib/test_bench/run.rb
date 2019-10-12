module TestBench
  class Run < Fixture::Run
    def output
      @output ||= Output::Substitute.build
    end

    def load_context
      @load_context ||= self.class.fixture(self)
    end
    attr_writer :load_context

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

    def self.fixture(instance)
      fixture = Object.new
      fixture.extend(Fixture)
      fixture.test_run = instance
      fixture
    end
  end
end
