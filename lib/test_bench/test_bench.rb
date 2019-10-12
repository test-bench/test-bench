module TestBench
  def self.run
    @run ||= Run.build.tap do |run|
      at_exit do
        exit 1 if run.failed?
      end
    end
  end
  singleton_class.attr_writer :run

  def self.output
    run.output
  end

  def self.output=(output)
    run.output = output
  end

  def self.activate(receiver=nil, run: nil)
    receiver ||= TOPLEVEL_BINDING.receiver
    run ||= self.run

    receiver.extend(Fixture)
    receiver.test_run = run
    receiver
  end

  def self.evaluate(run: nil, &block)
    run ||= self.run

    run.evaluate(->{
      fixture = Run.fixture(run)
      fixture.instance_exec(&block)
    })
  end
end
