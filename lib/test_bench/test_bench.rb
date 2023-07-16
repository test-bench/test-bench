module TestBench
  def self.context(title=nil, session: nil, &block)
    evaluate(session:) do
      context(title) do
        instance_exec(&block)
      end
    end
  end

  def self.evaluate(session: nil, &block)
    fixture = TestBench::Fixture::Evaluate.build(session:, &block)
    fixture.extend(DeactivationVariants)
    fixture.()

    fixture.test_session.passed?
  end

  def self.session
    Session::Store.get
  end

  module DeactivationVariants
    def _context(*, &)
      context(*)
    end

    def _test(*, &)
      test(*)
    end
  end
end
