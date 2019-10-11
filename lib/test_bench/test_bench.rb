module TestBench
  def self.run
    @run ||= Run.build.tap do |run|
      at_exit do
        exit 1 if run.failed?
      end
    end
  end
  singleton_class.attr_writer :run
end
