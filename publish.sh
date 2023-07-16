#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Publishing"
echo "= = ="

version=${1:-}
if [ -z "$version" ]; then
  echo "Usage: $0 VERSION"
  false
fi

rm -f *.gem

./package.sh $version

git push origin v$version
git push --force origin release

for gem in *.gem; do
  gem push $gem
done

echo
echo "Done ($(basename "$0"))"
