#!/usr/bin/env bash

brew install nvm
source $(brew --prefix nvm)/nvm.sh
nvm install 0.10
nvm use 0.10

# Install latest npm for node 0.10, default is obsolete
npm install -g npm@2.x
