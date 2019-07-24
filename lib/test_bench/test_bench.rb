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

    Run.fixture(run, receiver)
  end
end
