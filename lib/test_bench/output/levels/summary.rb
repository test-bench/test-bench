module TestBench
  module Output
    module Levels
      class Summary
        include TestBench::Fixture::Output

        include Output::Summary::Error
        include Output::Summary::Run

        def self.build(writer: nil, styling: nil, device: nil)
          instance = new
          Writer.configure(instance, writer: writer, styling: styling, device: device)
          instance
        end
      end
    end
  end
end
