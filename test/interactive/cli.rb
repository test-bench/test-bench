ENV['BOOTSTRAP'] ||= 'off'

require_relative '../../init'

require 'test_bench'

TestBench::CLI.()
