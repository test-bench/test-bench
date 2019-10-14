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

    def self.build(argv=nil, stdin: nil, test_run: nil, abort_on_error: nil, exclude_file_pattern: nil, omit_backtrace_pattern: nil, output_styling: nil, reverse_backtraces: nil, tests_directory: nil, verbose: nil)
      stdin ||= $stdin

      instance = new
      instance.stdin = $stdin

      run = Run.configure(instance, tests_directory, test_run: test_run, exclude_file_pattern: exclude_file_pattern)

      unless abort_on_error.nil?
        run.test_run.abort_on_error = abort_on_error
      end

      unless omit_backtrace_pattern.nil?
        run.test_run.output.omit_backtrace_pattern = omit_backtrace_pattern
      end

      unless output_styling.nil?
        run.test_run.output.writer.styling = output_styling
      end

      unless reverse_backtraces.nil?
        run.test_run.output.reverse_backtraces = reverse_backtraces
      end

      unless verbose.nil?
        run.test_run.output.verbose = verbose
      end

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
