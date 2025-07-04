# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name = 'TEMPLATE-GEM-NAME'
  spec.version = '0.0.0.0'

  spec.summary = "## Summary goes here"
  spec.description = <<~TEXT.each_line(chomp: true).map(&:strip).join(' ')
  ## Description goes here
  TEXT

  spec.homepage = 'TEMPLATE-HOMEPAGE'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/TEMPLATE-GITHUB-ORG/TEMPLATE-REPO-NAME'

  allowed_push_host = ENV.fetch('RUBYGEMS_PUBLIC_AUTHORITY') { 'https://rubygems.org' }
  spec.metadata['allowed_push_host'] = allowed_push_host

  spec.metadata['namespace'] = 'TEMPLATE-NAMESPACE'

  spec.license = 'MIT'

  spec.authors = ['Brightworks Digital']
  spec.email = 'development@bright.works'

  spec.require_paths = ['lib']

  spec.files = Dir.glob('lib/**/*')

  spec.platform = Gem::Platform::RUBY

  spec.add_development_dependency 'TEMPLATE-TEST-BENCH-GEM-NAME'
end
