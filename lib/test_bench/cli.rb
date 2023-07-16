module TestBench
  module CLI
    def self.call(...)
      path_arguments = ParseArguments.(...)

      default_path = Defaults.tests_directory

      result = Run.! do |run|
        if not STDIN.tty?
          until STDIN.eof?
            path = STDIN.gets(chomp: true)

            next if path.empty?

            run << path
          end
        end

        path_arguments.each do |path|
          run << path
        end

        if not run.ran?
          run << default_path
        end
      end

      exit_code = exit_code(result)

      exit(exit_code)
    end

    def self.exit_code(result)
      if result == true
        0
      elsif result == false
        1
      else
        2
      end
    end

    module Defaults
      def self.tests_directory
        ParseArguments::Defaults.tests_directory
      end
    end
  end
end
