require_relative 'test_init'

TestBenchIsolated::TestBench::Run.(
  'test/automated',
  exclude_file_pattern: '**/{_*,sketch*,*_init.rb,*_tests.rb}'
) or exit(false)
