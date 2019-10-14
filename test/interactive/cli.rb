ENV['BOOTSTRAP'] ||= 'off'

require_relative './interactive_init'

TestBench::CLI.(
  abort_on_error: false,
  exclude_file_pattern: /_init.rb$/,
  omit_backtrace_pattern: /lib\/test_bench/,
  output_styling: :detect,
  reverse_backtraces: false,
  tests_directory: 'test/automated',
  verbose: false
)
