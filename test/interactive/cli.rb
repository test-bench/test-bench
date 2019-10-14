ENV['BOOTSTRAP'] ||= 'off'

require_relative './interactive_init'

TestBench::CLI.()
