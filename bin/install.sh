#!/bin/sh

DIR=`pwd`
chmod 711 url-status.sh
cd ~/bin
ln -s $DIR/url-status.sh url-status
