module TestBench
  module CLI
    def self.call(tests_directory=nil, **runner_args)
      tests_directory ||= Defaults.tests_directory

      path_arguments = ParseArguments.()

      read_stdin = $stdin.stat.pipe?

      if read_stdin && $stdin.eof?
        warn "$stdin is a pipe, but no data was written to it; no test files will be run"
      end

      Run.(**runner_args) do |run|
        if read_stdin
          until $stdin.eof?
            path = $stdin.gets.chomp

            next if path.empty?

            run.path(path)
          end
        end

        if path_arguments.empty?
          unless read_stdin
            run.path(tests_directory)
          end
        else
          path_arguments.each do |path|
            run.path(path)
          end
        end
      end
    end

    module Defaults
      def self.tests_directory
        ENV.fetch('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
      end
    end
  end
end
