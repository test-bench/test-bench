#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

rm -f {.,*}/*.gem

./package.sh

echo
echo "Publishing"
echo "= = ="

if [ -z "${RUBYGEMS_PRIVATE_AUTHORITY:-}" ]; then
  printf "\n\e[31mError: RUBYGEMS_PRIVATE_AUTHORITY is not set\e[39m\n"
  false
fi
rubygems_private_authority=$RUBYGEMS_PRIVATE_AUTHORITY
rubygems_private_authority_access_key=${RUBYGEMS_PRIVATE_AUTHORITY_ACCESS_KEY:-}

if [ -z "${RUBYGEMS_PUBLIC_AUTHORITY:-}" ]; then
  printf "\n\e[31mError: RUBYGEMS_PUBLIC_AUTHORITY is not set\e[39m\n"
  false
fi
rubygems_public_authority=$RUBYGEMS_PUBLIC_AUTHORITY
rubygems_public_authority_access_key=${RUBYGEMS_PUBLIC_AUTHORITY_ACCESS_KEY:-}

function get_gemspec_attr() {
  gem_file=$1
  attr=$2
  metadata_attr=${3:-}

  ruby_cmd="puts YAML.parse(STDIN.read).to_ruby"

  if [ -n "$metadata_attr" ]; then
    ruby_cmd="$ruby_cmd['$metadata_attr']"
  fi

  gem spec $gem_file $attr | ruby -ryaml -rrubygems -e "$ruby_cmd"
}

for gem in $(find . -maxdepth 2 -name '*.gem'); do
  echo
  echo "Gem: $(basename "$gem")"
  echo "- - -"

  license="$(get_gemspec_attr "$gem" license)"
  echo "License: ${license:-(none)}"

  if [ -n "$license" ]; then
    rubygems_authority="$rubygems_public_authority"
    rubygems_authority_access_key="$rubygems_public_authority_access_key"
  else
    rubygems_authority="$rubygems_private_authority"
    rubygems_authority_access_key="$rubygems_private_authority_access_key"
  fi
  echo "Rubygems Authority: $rubygems_authority"

  cmd="gem push"
  if [ -n "$rubygems_authority_access_key" ]; then
    cmd="$cmd --key $rubygems_authority_access_key"
  fi
  cmd="$cmd --host $rubygems_authority \"$gem\""

  echo "$cmd"
  eval "$cmd || true"
done

echo
echo "Done ($(basename "$0"))"
