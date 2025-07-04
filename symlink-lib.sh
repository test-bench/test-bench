#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

if [ -z "${LIBRARIES_HOME:-}" ]; then
  echo "LIBRARIES_HOME must be set to the libraries directory path... exiting"
  false
fi

if [ ! -d "$LIBRARIES_HOME" ]; then
  echo "$LIBRARIES_HOME does not exist... exiting"
  false
fi

make-symlink() {
  source="$1"
  target="$2"

  echo
  echo "Source: $source"
  echo "Target: $target"
  echo

  if ! [ -L "$target" ]; then
    cmd="ln -s \"$source\" \"$target\""
    echo "$cmd"
    eval "$cmd"
  else
    echo "Already symlinked "\"$source\" to \"$target\"
  fi
}

echo
echo "Symlinking project"
echo "- - -"

project_name="$(basename "$(pwd)")"
make-symlink "$(pwd)/gems/lib/bundle/setup.rb" "$LIBRARIES_HOME/${project_name}-bundle-setup.rb"

echo
echo "Done ($(basename "$0"))"
