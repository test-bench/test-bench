module TestBench
  class Run
    def session
      @session ||= Fixture::Session::Substitute.build
    end
    attr_writer :session

    attr_reader :paths

    def initialize(*paths)
      @paths = Array(paths)
    end

    def call(&block)
      session.start

      if block.nil?
        paths.each do |path|
          path(path)
        end
      else
        block.()
      end

    ensure
      session.finish
    end

    def path(path)
      if File.exist?(path)
        file(path)
      end
    end

    def file(path)
      session.load(path)
    end
  end
end
