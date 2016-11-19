#/bin/bash

download_extract() {
	aria2c -x 16 $1 -o $2
	tar -xf $2
}

travis_before_install() {
	git submodule update --init --recursive
}

travis_install() {
	sudo apt-get update
	sudo apt-get -y install aria2
	
	sudo apt-get install lib32stdc++6 lib32bz2-1.0 -qq
	download_extract https://github.com/xsacha/SymbianGCC/releases/download/4.8.3/gcc4.8.3_x86-64.tar.bz2 compiler.tar.bz2
	download_extract https://github.com/xsacha/SymbianGCC/releases/download/4.8.3/ndk-new.tar.bz2 ndk.tar.bz2
	export EPOCROOT=$(pwd)/SDKs/SymbianSR1Qt474/ SBS_GCCE483BIN=$(pwd)/gcc4.8.3_x86-64/bin
}

travis_script() {

	
	export EPOCROOT=$(pwd)/SDKs/SymbianSR1Qt474 COMPILERROOT=$(pwd)/gcc4.8.3_x86-64 
	export SBS_GCCE483BIN=$COMPILERROOT/bin
	PATH=$SBS_GCCE483BIN:$(pwd)/tools/sbs/bin:$EPOCROOT/epoc32/tools:$EPOCROOT/bin:$(pwd)/tools/sbs/linux-x86_64-libc2_15/bin:$PATH
	which qmake
	
	download_extract ftp://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz nettle
	cd nettle-3.3
	CC=arm-none-symabianelf-gcc ./configure --prefix=$HOME/out --host=arm-none-symbianelf
}


set -e
set -x

$1;
