#!/usr/bin/env bash

set -eu -o pipefail

echo
echo "Creating Package"
echo "= = ="
echo

if [ -z ${VERSION:-} ]; then
  version=0
  echo "(VERSION isn't set; $version will be used)"
else
  version=$VERSION
fi
echo "Version: $version"

tag_name="v$version"
echo "Tag: $tag_name"

git tag $tag_name

VERSION=$version gem build *.gemspec

echo
echo "(done)"
echo "- - -"
echo
