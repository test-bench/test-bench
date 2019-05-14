require_relative './test_init'

if Object.const_defined?(:TestBench) && TestBench.const_defined?(:Bootstrap)
  TestBench::Bootstrap::Run.()
else
  TestBench::CLI.()
end
