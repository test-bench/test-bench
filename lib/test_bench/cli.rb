module TestBench
  class CLI
    def run
      @run ||= Run::Substitute.build
    end
    attr_writer :run

    def argv
      @argv ||= []
    end
    attr_writer :argv

    def stdin
      @stdin ||= StringIO.new
    end
    attr_writer :stdin

    def self.build(argv=nil, stdin: nil, test_run: nil)
      stdin ||= $stdin

      instance = new
      instance.stdin = $stdin

      run = Run.configure(instance, test_run: test_run)

      instance.argv = ParseArguments.(argv, run: run)

      instance
    end

    def self.call(argv=nil, **args)
      instance = build(argv, **args)
      instance.()
    end

    def call
      run.() do |paths|
        unless stdin.tty?
          until stdin.eof?
            path = stdin.gets.chomp

            paths << path
          end
        end

        argv.each do |path|
          paths << path
        end
      end
    end
  end
end
