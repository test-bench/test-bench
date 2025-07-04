#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Run Tests"
echo "= = ="

if [ -f test/automated.rb ]; then
  echo
  echo "Automated Tests"
  echo "- - -"

  ruby test/automated.rb
fi

echo "Done ($(basename "$0"))"
