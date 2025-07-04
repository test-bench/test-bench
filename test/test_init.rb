ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

ENV['TEST_FIXTURE_DETAIL'] ||= ENV['D']

puts RUBY_DESCRIPTION

require_relative '../init'
require 'TEMPLATE-PATH/controls'

require 'pp'

require 'TEMPLATE-TEST-BENCH-GEM-NAME'; TEMPLATE-TEST-BENCH-NAMESPACE.activate

#TestBench::ImportConstants.(TEMPLATE-NAMESPACE)
