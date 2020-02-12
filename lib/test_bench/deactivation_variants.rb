module TestBench
  module DeactivationVariants
    def _context(title=nil, &block)
      context(title)
    end

    def _test(title=nil, &block)
      test(title)
    end
  end
end
