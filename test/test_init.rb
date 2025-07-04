ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

ENV['TEST_FIXTURE_DETAIL'] ||= ENV['D']

puts RUBY_DESCRIPTION

require_relative '../init'
require 'test_bench/controls'

require 'pp'

require 'test_bench_bootstrap'; TestBenchBootstrap.activate

TestBenchBootstrap::ImportConstants.(TestBench)
