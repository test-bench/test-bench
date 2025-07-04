#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Packaging"
echo "= = ="

warning=0

for gemspec in $(find . -maxdepth 2 -name '*.gemspec'); do
  echo
  echo "Gem: $(basename "$gemspec")"
  echo "- - -"

  path="$(dirname "$gemspec")"
  gem -C "$path" build --force "$(basename "$gemspec")"
done

if ! git diff --quiet; then
  echo
  printf "\e[31mWarning: There are local changes\e[m\n"

  warning=1
fi

unpushed_commit_count=$(git rev-list origin/master.. --count)
if [ "$unpushed_commit_count" -ne 0 ]; then
  echo
  printf "\e[31mWarning: There are %d unpushed commits\e[m\n" "$unpushed_commit_count"

  warning=1
fi

if [ "$warning" = 1 ] && [ "${PERMIT_WARNINGS:-}" != "on" ]; then
  false
fi

echo
echo "Done ($(basename "$0"))"
