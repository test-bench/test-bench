# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'test_bench'
  s.version = '2.1.2'

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd+github@gmail.com'
  s.homepage = 'https://github.com/test-bench/test-bench'
  s.licenses = %w(MIT)
  s.summary = "Design-oriented test framework"
  s.platform = Gem::Platform::RUBY

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'

  s.add_dependency 'test_bench-fixture', '= 1.1.0'

  s.add_development_dependency 'test_bench-bootstrap', '= 1.1.0'
end
