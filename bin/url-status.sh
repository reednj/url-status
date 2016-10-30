#!/bin/bash

DIR="$(dirname "$(readlink "$0")")"
DIR=$DIR/..
/usr/bin/env ruby $DIR/app.rb "$@"
