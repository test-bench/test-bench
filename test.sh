#!/bin/sh

set -eu -o pipefail

if [ -x test-setup.sh ]; then
  ./test-setup.sh
fi

ruby test/automated.rb
