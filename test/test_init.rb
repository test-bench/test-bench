require_relative '../init'

require 'test_bench/isolated'; TestBenchIsolated::TestBench.activate

require 'test_bench/controls'

include TestBench

Controls = TestBench::Controls rescue nil
