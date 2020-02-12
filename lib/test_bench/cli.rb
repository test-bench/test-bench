module TestBench
  module CLI
    def self.call(tests_directory=nil, **runner_args)
      tests_directory ||= Defaults.tests_directory

      path_arguments = ParseArguments.()

      read_stdin = self.read_stdin?

      Run.(**runner_args) do |paths|
        if read_stdin
          until $stdin.eof?
            path = $stdin.gets.chomp

            next if path.empty?

            paths << path
          end
        end

        if path_arguments.empty?
          unless read_stdin
            paths << tests_directory
          end
        else
          path_arguments.each do |path|
            paths << path
          end
        end
      end
    end

    def self.read_stdin?
      $stdin.stat.pipe? && !$stdin.eof?
    end

    module Defaults
      def self.tests_directory
        ENV.fetch('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
      end
    end
  end
end
