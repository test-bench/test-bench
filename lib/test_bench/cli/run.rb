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

      def call(&block)
        test_run.start

        block.(self) unless block.nil?

        test_run.finish
      end

      def path(path)
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
      end
    end
  end
end
