unless RUBY_ENGINE == 'mruby'
  require 'optionparser'
end

require 'test_bench/fixture'

require 'test_bench/environment/boolean'

require 'test_bench/output/writer'
require 'test_bench/output/writer/sgr'
require 'test_bench/output/writer/substitute'
