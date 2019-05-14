#!/usr/bin/env sh

set -eu

irb \
  -I gems \
  -I lib/ \
  -r bundler/setup \
  -r test_bench \
  -r test_bench/controls \
  --readline \
  --prompt simple \
  $@
