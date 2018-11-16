#!/bin/bash

# linux
cd $TRAVIS_BUILD_DIR
sudo apt update && sudo apt install libgtk2.0-dev
wget http://mahjong.julianbradfield.org/Source/mj-1.14-src.tar.gz
tar xf mj-1.14-src.tar.gz
cd mj-1.14-src
make

# termux-x11
cd $TRAVIS_BUILD_DIR
wget https://transfer.sh/5NDQZ/packages.tar.xz
tar xf packages.tar.xz

