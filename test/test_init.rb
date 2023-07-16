ENV['BOOTSTRAP'] ||= 'on'

require_relative '../init'

if ENV['BOOTSTRAP'] == 'on'
  require 'test_bench/bootstrap'; TestBench::Bootstrap.activate
else
  require 'test_bench'; TestBench.activate
end

require 'test_bench/controls'

include TestBench

Controls = TestBench::Controls rescue nil
