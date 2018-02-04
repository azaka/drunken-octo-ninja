#! /bin/sh -e

# builds https://github.com/Vita3K/Vita3K

# wget
# runs as root
# ubuntu 16.04

sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/test
sudo apt-add-repository --yes ppa:zoogie/sdl2-snapshots 
sudo apt-get update -q
sudo apt-get install libsdl2-dev g++-5 -q -y
sudo apt-get remove libsdl2-dev cmake -q -y

cd $TRAVIS_BUILD_DIR
git clone --depth 1 https://github.com/Vita3K/Vita3K
cd Vita3K
git submodule init && git submodule update
mkdir build-linux && cd build-linux
export BUILD_DIR=$(pwd)

# cmake 3.8
wget https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz
tar -xf cmake-3.10.2.tar.gz

cd cmake-3.10.2
./configure
# checkinstall
make -j7 && sudo make install

# sdl 2.0.7
cd $BUILD_DIR
wget https://www.libsdl.org/release/SDL2-2.0.7.tar.gz
tar -xf SDL2-2.0.7.tar.gz
cd SDL2-2.0.7
./configure
make -j7 && sudo make install

# unicorn
cd $BUILD_DIR
wget https://github.com/unicorn-engine/unicorn/archive/1.0.1.tar.gz
tar -xf 1.0.1.tar.gz
cd unicorn-1.0.1
./make.sh
sudo make install

# vita3k
cd $BUILD_DIR
# g++-5
cmake .. -DCMAKE_CXX_COMPILER=g++-5
#cmake ..

make -j7 && sudo make install

# src/emulator/Vita3k <vpk file>
