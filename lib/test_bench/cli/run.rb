module TestBench
  class CLI
    class Run
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
        if File.exist?(path)
          file(path)
        end
      end
      alias_method :<<, :path

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
