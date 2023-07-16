#!/usr/bin/env sh

set -eu -o pipefail

irb \
  -r ./test/test_init.rb \
  --readline \
  --prompt simple \
  $@
