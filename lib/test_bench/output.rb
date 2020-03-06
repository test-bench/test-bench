module TestBench
  module Output
    def self.build(**args)
      Build.(**args)
    end

    Substitute = Fixture::Output::Substitute
  end
end
