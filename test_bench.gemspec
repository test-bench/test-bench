# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'test_bench'
  s.version = '1.2.0.4'

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd+github@gmail.com'
  s.homepage = 'https://github.com/test-bench/test-bench'
  s.licenses = %w(MIT)
  s.summary = "Principled Test Framework for Ruby"
  s.platform = Gem::Platform::RUBY

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'

  s.bindir = 'script'
  s.executables << 'bench'

  s.add_dependency 'test_bench-fixture', '>= 1.0.0.0'

  s.add_development_dependency 'test_bench-bootstrap'
end
