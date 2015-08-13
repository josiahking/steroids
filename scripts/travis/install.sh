#!/usr/bin/env bash

cd "$(dirname "$0")"

UNAME=$(uname)

if [ "$UNAME" = "Darwin" ]; then
  echo "running install_osx.sh"
  ./install_osx.sh
elif [ "$UNAME" = "Linux" ]; then
  echo "running install_linux.sh"
  ./install_linux.sh
else
  echo "Unknown uname: $UNAME"
fi

# Announce node and npm versions for build debuggability
echo node version: $(node --version)
echo npm version: $(npm -v)
