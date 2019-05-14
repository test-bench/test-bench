require_relative '../init'

unless ENV['BOOTSTRAP'] == 'off'
  require 'test_bench/bootstrap'; TestBench::Bootstrap.activate
else
  require 'test_bench'; TestBench.activate
end

require 'test_bench/controls'
require 'test_bench/fixtures'

include TestBench
