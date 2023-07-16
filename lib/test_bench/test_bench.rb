module TestBench
  def self.session
    Session::Store.get
  end
end
