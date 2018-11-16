#!/bin/bash

# builds under linux
git clone https://github.com/kode54/vgmstream
cd vgmstream
git checkout 29c1e5

sudo add-apt-repository ppa:nilarimogard/webupd8 -y
sudo apt-get update && sudo apt-get install libmpg123-dev \
libvorbis-dev audacious-dev libglib2.0-dev libgtk2.0-dev libpango1.0-dev

./bootstrap
./configure
make -j7 -f Makefile.autotools

