# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'test_bench'
  s.version = ENV.fetch('VERSION', '0')

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd+github@gmail.com'
  s.homepage = 'https://github.com/test-bench/test-bench'
  s.licenses = %w(MIT)
  s.summary = # "Some summary"
  s.platform = Gem::Platform::RUBY

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'

  s.bindir = 'script'
  s.executables << 'bench'

  s.add_runtime_dependency 'test_bench-run'
  ## Remove entry for test_bench-fixture altogether when v2 of test_bench-fixture has been published
  s.add_runtime_dependency 'test_bench-fixture', '~> 2.1.0.0.pre3'

  s.add_development_dependency 'test_bench-isolated'
end
