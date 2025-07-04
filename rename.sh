#!/usr/bin/env bash

set -euo pipefail

function rename-directories {
  local replacement=$1

  for dir in $(find . -type d -name "*template*"); do
    local dest="${dir//template/$replacement}"

    mkdir -vp "$(dirname "$dest")"
    mv -v "$dir" "$dest"
  done
}

function rename-files {
  local replacement=$1

  for file in $(find . -type f -name "*template*"); do
    local dest="${file//template/$replacement}"

    mkdir -vp "$(dirname "$dest")"
    mv -v "$file" "$dest"
  done
}

function replace-tokens {
  local token=$1
  local replacement=$2

  echo "Replacing $token with $replacement"

  files=$(grep --exclude rename.sh -rl "$token" .)

  if grep -q "GNU sed" <<<$(sed --version 2>/dev/null); then
    xargs sed -i "s/$token/${replacement//\//\\/}/g" <<<"$files"
  else
    xargs sed -i '' "s/$token/${replacement//\//\\/}/g" <<<"$files"
  fi
}

function title-case {
  set ${*,,}
  echo ${*^}
}

if [ "$#" -ne 3 ]; then
  echo "Usage: rename.sh <gem-name> <namespace> <homepage>"
  echo "e.g. rename.sh some_namespace-other_namespace SomeNamespace::OtherNamespace http://example.com"
  exit 1
fi

gem_name=$1
repo_name=${gem_name//_/-}
project_name=$(title-case "${repo_name//-/ }")
path=${gem_name//-/\/}

namespace=$2
homepage=$3

github_org=${GIT_AUTHORITY_PATH#git@github.com:}

if [ "${TEST_BENCH_BOOTSTRAP:-off}" = "on" ]; then
  test_bench_gem_name="test_bench_bootstrap"
  test_bench_namespace="TestBenchBootstrap"
else
  test_bench_gem_name="test_bench"
  test_bench_namespace="TestBench"
fi

echo
echo "Renaming Project"
echo "= = ="
echo
echo "Gem Name: $gem_name"
echo "Repository Name: $repo_name"
echo "Project Name: $project_name"
echo "Lib Path: lib/$path"
echo "Namespace: $namespace"
echo "GitHub Organization: $github_org"
echo "Homepage: $homepage"
echo "TestBench Gem Name: $test_bench_gem_name"
echo "TestBench Namespace: $test_bench_namespace"

if [ "${PROMPT:-on}" = "on" ]; then
  echo
  echo "If everything is correct, press return (Ctrl+c to abort)"
  read -r
fi

echo
echo "Writing $gem_name.gemspec"
echo "- - -"
mv -v template.gemspec "$gem_name.gemspec"

echo
echo "Renaming directories"
echo "- - -"
rename-directories "$path"

echo
echo "Renaming files"
echo "- - -"
rename-files "$path"

echo
echo "Replacing tokens"
echo "- - -"
replace-tokens "TEMPLATE-GEM-NAME" "$gem_name"
replace-tokens "TEMPLATE-REPO-NAME" "$repo_name"
replace-tokens "TEMPLATE-PROJECT-NAME" "$project_name"
replace-tokens "TEMPLATE-PATH" "$path"
replace-tokens "TEMPLATE-NAMESPACE" "$namespace"
replace-tokens "TEMPLATE-GITHUB-ORG" "$github_org"
replace-tokens "TEMPLATE-HOMEPAGE" "$homepage"
replace-tokens "TEMPLATE-TEST-BENCH-GEM-NAME" "$test_bench_gem_name"
replace-tokens "TEMPLATE-TEST-BENCH-NAMESPACE" "$test_bench_namespace"

echo
echo "Writing README"
echo "- - -"
mv -v TEMPLATE-README.md README.md

echo
echo "Installing gems"
echo "- - -"
./install-gems.sh

echo
echo "Running example test"
echo "- - -"
ruby -w -r./test/automated/automated_init.rb <<'RUBY'
context "Example Context" do
  test "Some test" do
    assert(true)
  end
end
RUBY

echo
echo "Deleting rename.sh"
echo "- - -"
rm -v rename.sh

echo
echo "- - -"
echo "(done)"
