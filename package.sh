#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Packaging"
echo "= = ="

version=${1:-}
if [ -z "$version" ]; then
  echo "Usage: $0 VERSION"
  false
fi

version_pattern="^([0-9]+\.){2,3}[0-9]+(\.pre[0-9]*)?$"
if [[ ! "$version" =~ $version_pattern ]]; then
  echo -e "\e[1;31mError: argument \`$version' isn't a version\e[39;22m (Examples: \e[3m1.2.3, 2.0.0.0, 3.0.0.pre1\e[23m)"
  false
fi

echo "Version: $version"

version_pattern="${version//\./\\.}"

warning=0

version_tag="v$version"
commit=$(git rev-parse --quiet --verify $version_tag || true)
if [ -z "$commit" ]; then
  echo -e "\e[1;33mWarning: no tag named $version_tag\e[39;22m"
  warning=1
elif [ -z $(git tag --points-at HEAD | grep "$version_tag") ]; then
  echo -e "\e[1;33mWarning: tag $version doesn't reference HEAD\e[39;22m"
  warning=1
elif ! git diff --quiet; then
  echo -e "\e[1;33mWarning: there are local changes\e[39;22m"
  warning=1
else
  echo "Commit: ${commit:-(none)}"
fi

remote_branch=$(git status --short --branch --porcelain | grep --only-matching --extended-regexp 'origin/[-a-z]+')
unpushed_commit_count=$(git rev-list $remote_branch.. --count)
if [ "$unpushed_commit_count" -ne 0 ]; then
  echo -e "\e[1;33mWarning: local branch has unpushed commits\e[39;22m"
  warning=1
fi

if [ -z $(git tag --points-at HEAD | grep '^release$') ]; then
  echo -e "\e[1;33mWarning: tag \`release' doesn't reference HEAD \e[39;22m"
  warning=1
fi

remote_tag_pattern="refs/tags/v${version_pattern}"
remote_tag=$(git ls-remote --exit-code --tags --quiet | sed -E -n "s|^$commit\t($remote_tag_pattern)$|\1|p" || true)
if [ ! -z "$remote_tag" ]; then
  echo -e "\e[1;33mWarning: origin already has tag \`$version'\e[39;22m"
  warning=1
fi
echo

echo "Building Gem"
echo "- - -"

for gemspec in *.gemspec; do
  echo
  VERSION=$version gem build --force --norc $gemspec
done

if [ "$warning" = 1 ] && [ "${PERMIT_WARNINGS:-}" != "on" ]; then
  false
fi

echo
echo "Done ($(basename $0))"
