#!/usr/bin/env bash

set -eu -o pipefail

if [ -z ${LIBRARIES_HOME+x} ]; then
  echo "LIBRARIES_HOME must be set to the libraries directory path... exiting"
  exit 1
fi

if [ ! -d "$LIBRARIES_HOME" ]; then
  echo "$LIBRARIES_HOME does not exist... exiting"
  exit 1
fi

function make-directory {
  directory=$1

  lib_directory="$LIBRARIES_HOME/$directory"

  if [ ! -d "$lib_directory" ]; then
    echo "- making directory $lib_directory"
    mkdir -p "$lib_directory"
  fi
}

function symlink-lib {
  name="$(basename "$1")"
  directory="$(dirname "$1")"

  if [ "$directory" = "." ]; then
    directory=
  fi

  echo
  echo "Symlinking $name"
  echo "- - -"

  src="$(pwd)/lib"
  dest="$LIBRARIES_HOME"
  if [ -n "$directory" ]; then
    src="$src/$directory"
    dest="$dest/$directory"

    make-directory "$directory"
  fi
  src="$src/$name"

  echo "- destination is $dest"

  for entry in "$src"*; do
    entry_basename="$(basename "$entry")"
    dest_item="$dest/$entry_basename"

    if ! [ -L "$dest_item" ]; then
      echo "- symlinking $entry_basename to $dest_item"

      cmd="ln -s $entry $dest_item"
      echo "$cmd"
      ($cmd)
    else
      echo "- $dest_item is already symlinked"
    fi
  done

  echo "- - -"
  echo "($name done)"
  echo
}

symlink-lib "test_bench"
