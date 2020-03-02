module TestBench
  module Controls
    module Output
      module NewlineCharacter
        def self.example
          str = String.new

          string_io = StringIO.new(str)
          string_io.puts('')

          str
        end
      end
    end
  end
end
