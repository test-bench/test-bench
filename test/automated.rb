require_relative 'test_init'

TEMPLATE-TEST-BENCH-NAMESPACE::Run.(
  'test/automated',
  exclude: '{_*,*sketch*,*_init,*_tests}.rb'
) or exit(false)
