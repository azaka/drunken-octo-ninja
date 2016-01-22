#!/bin/bash
sudo add-apt-repository --yes ppa:tobydox/mingw-x-trusty
sudo apt-get update -qq
sudo apt-cache search mingw
sudo apt-get install -y gcc-mingw-w64-i686 mingw-x-freetype mingw-x-libogg mingw-x-zlib
where gcc
gcc -v