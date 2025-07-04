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

echo
echo "Removing project symlink"
echo "- - -"

project_name="$(basename "$(pwd)")"

symlink_path="$LIBRARIES_HOME/${project_name}-bundle-setup.rb"
if [ -L "$symlink_path" ]; then
  cmd="rm -f $symlink_path"
  echo "$cmd"
  eval "$cmd"
else
  echo "Symlink already removed"
fi

echo
echo "Done ($(basename "$0"))"
