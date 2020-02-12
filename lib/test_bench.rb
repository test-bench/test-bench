require 'optionparser'

require 'test_bench/fixture'

require 'test_bench/environment/boolean'

require 'test_bench/output/writer'
require 'test_bench/output/writer/sgr'
require 'test_bench/output/writer/substitute'
require 'test_bench/output/writer/dependency'

require 'test_bench/output/timer'
require 'test_bench/output/timer/substitute'

require 'test_bench/output/print_error'

require 'test_bench/output/summary/run/print'
require 'test_bench/output/summary/run'
require 'test_bench/output/summary/error'

require 'test_bench/output/levels/none'
require 'test_bench/output/levels/summary'
require 'test_bench/output/levels/failure'
require 'test_bench/output/levels/debug'
require 'test_bench/output/levels/pass'

require 'test_bench/output/build'
require 'test_bench/output'

require 'test_bench/test_bench'
require 'test_bench/deactivation_variants'

require 'test_bench/run'
require 'test_bench/run/substitute'

require 'test_bench/cli/parse_arguments'
require 'test_bench/cli'
