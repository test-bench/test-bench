module TestBench
  class Run
    Error = Class.new(RuntimeError)

    def session
      @session ||= Session::Substitute.build
    end
    attr_writer :session

    def exclude_pattern
      @exclude_pattern ||= Defaults.exclude_pattern
    end
    attr_writer :exclude_pattern

    attr_reader :paths

    def initialize(*paths)
      @paths = Array(paths)
    end

    def self.build(*paths, exclude: nil, session: nil, output: nil)
      session ||= TestBench.session

      instance = new(*paths)

      instance.exclude_pattern = exclude unless exclude.nil?

      Session.configure(instance, session: session)
      instance.session.output = output unless output.nil?

      instance
    end

    def self.configure(receiver, *paths, attr_name: nil, **args)
      attr_name ||= :run

      instance = build(*paths, **args)
      receiver.public_send(:"#{attr_name}=", instance)
      instance
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
      if File.directory?(path)
        directory(path)
      elsif File.exist?(path)
        file(path)
      else
        raise Error, "Path not found (Path: #{path.inspect})"
      end
    end

    def directory(path)
      glob_pattern = File.join(path, '**/*.rb')

      Dir[glob_pattern].sort.each do |path|
        next if exclude_pattern.match?(path)

        file(path)
      end
    end

    def file(path)
      session.load(path)
    end

    module Defaults
      def self.exclude_pattern
        pattern = ENV.fetch('TEST_BENCH_EXCLUDE_FILE_PATTERN') do
          '_init.rb$'
        end

        Regexp.new(pattern)
      end
    end
  end
end
