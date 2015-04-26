#!/usr/bin/env bash

BASEDIR=$(dirname $0)
cd $BASEDIR

berks upload --except=integration "$@"
