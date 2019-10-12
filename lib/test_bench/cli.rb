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
