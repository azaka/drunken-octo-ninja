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
	# this script installs GCC 4.9.3 
	# to use it navigate to your home directory and type:
	# sh install-gcc-4.9.3.sh

	# download and install gcc 4.9.3
	wget https://ftp.gnu.org/gnu/gcc/gcc-4.9.3/gcc-4.9.3.tar.gz
	tar xzf gcc-4.9.3.tar.gz
	cd gcc-4.9.3
	./contrib/download_prerequisites
	cd ..
	mkdir objdir

	cd objdir
	../gcc-4.9.3/configure --prefix=$HOME/gcc-4.9.3 --enable-languages=c,c++,fortran,go --disable-multilib
	make

	# install
	make install

	# clean up
	rm -rf ~/objdir
	rm -f ~/gcc-4.9.3.tar.gz

	# add to path (you may want to add these lines to $HOME/.bash_profile)
	export PATH=$HOME/gcc-4.9.3/bin:$PATH
	export LD_LIBRARY_PATH=$HOME/gcc-4.9.3/lib:$HOME/gcc-4.9.3/lib64:$LD_LIBRARY_PATH
	
	which gcc

}


set -e
set -x

$1;
