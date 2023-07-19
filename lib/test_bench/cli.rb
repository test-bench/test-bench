module TestBench
  module CLI
    def self.exit_code(result)
      if result == true
        0
      elsif result == false
        1
      else
        2
      end
    end
  end
end
