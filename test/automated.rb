require_relative 'test_init'

TestBenchIsolated::TestBench::Run.(
  'test/automated',
  exclude: '{_*,*sketch*,*_init,*_tests}.rb'
) or exit(false)
