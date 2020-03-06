module TestBench
  module Output
    module Levels
      class Summary
        include TestBench::Fixture::Output

        include Output::Summary::Error
        include Output::Summary::Run

        def self.build(writer: nil, styling: nil, device: nil)
          warn "Warning: #{self} is deprecated. It will remain in the TestBench v2 series, but will be removed from TestBench v3"

          instance = new
          Writer.configure(instance, writer: writer, styling: styling, device: device)
          Timer.configure(instance)
          instance
        end
      end
    end
  end
end
