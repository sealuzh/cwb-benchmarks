#!/usr/bin/env bash

BASEDIR=$(dirname $0)
cd $BASEDIR

CHEF_DIR=$HOME/.chef
BERKS_DIR=$HOME/.berkshelf

# $1 directory to check for existence
function check_dir_exists() {
  if [ -d "$1" ]; then
    echo "$1 already exists => abort to prevent overwriting existing config"
    exit 1
  fi
}

check_dir_exists $BERKS_DIR
mkdir $HOME/.berkshelf
cp config.json $HOME/.berkshelf/config.json

check_dir_exists $CHEF_DIR
mkdir $HOME/.chef
cp knife.rb $HOME/.chef/knife.rb
cp cwb-user.pem $HOME/.chef/cwb-user.pem
