module TestBench
  class CLI
    class Run
      Error = Class.new(RuntimeError)

      def test_run
        @test_run ||= TestBench::Run::Substitute.build
      end
      attr_writer :test_run

      def exclude_file_pattern
        @exclude_file_pattern ||= Defaults.exclude_file_pattern
      end
      attr_writer :exclude_file_pattern

      def tests_directory
        @tests_directory ||= Defaults.tests_directory
      end
      attr_writer :tests_directory

      def path_counter
        @path_counter ||= 0
      end
      attr_writer :path_counter

      def self.build(tests_directory=nil, exclude_file_pattern: nil, test_run: nil)
        test_run ||= TestBench.run

        instance = new
        instance.tests_directory = tests_directory unless tests_directory.nil?
        instance.exclude_file_pattern = exclude_file_pattern unless exclude_file_pattern.nil?
        instance.test_run = test_run
        instance
      end

      def self.call(tests_directory=nil, **args)
        instance = build(tests_directory, **args)
        instance.()
      end

      def self.configure(receiver, tests_directory=nil, attr_name: nil, **arguments)
        attr_name ||= :run

        instance = build(tests_directory, **arguments)
        receiver.public_send(:"#{attr_name}=", instance)
        instance
      end

      def call(&block)
        test_run.start

        block.(self) unless block.nil?

        if path_counter.zero?
          path(tests_directory)
        end

        test_run.finish
      end

      def path(path)
        self.path_counter += 1

        if File.directory?(path)
          directory(path)
        elsif File.exist?(path)
          file(path)
        else
          raise Error, "Path not found (Path: #{path.inspect})"
        end
      end
      alias_method :<<, :path

      def directory(path)
        glob_pattern = File.join(path, '**', '*.rb')

        Dir[glob_pattern].sort.each do |file_path|
          file(file_path)
        end
      end

      def file(path)
        if exclude_file_pattern.match?(path)
          return nil
        end

        test_run.load(path)
      end

      module Defaults
        def self.exclude_file_pattern
          pattern = ENV.fetch('TEST_BENCH_EXCLUDE_FILE_PATTERN') do
            '_init.rb$'
          end

          Regexp.new(pattern)
        end

        def self.tests_directory
          ENV.fetch('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
        end
      end
    end
  end
end
