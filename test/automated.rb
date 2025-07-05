require_relative 'test_init'

TestBenchBootstrap::Run.(
  'test/automated',
  exclude: '{_*,*sketch*,*_init,*_tests}.rb'
) or exit(false)
