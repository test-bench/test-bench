module TestBench
  def self.session
    Session::Store.fetch
  end
end
