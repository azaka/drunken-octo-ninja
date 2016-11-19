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
	
	EPOCINC=$EPOCROOT/epoc32/include
	SYSCFLAGS="-D__SUPPORT_CPP_EXCEPTIONS__ -D_UNICODE -D__SYMBIAN32__ -D__EPOC32__ -D__MARM__ -D__EABI__ -DPRODUCT_INCLUDE='"/home/travis/build/azaka/drunken-octo-ninja/SDKs/SymbianSR1Qt474/epoc32/include/variant/platform_paths.hrh"' -DUNICODE -D__MARM_ARMV5__ -D__ARMV6__ -D__GCCE_4__ -D__GCCE_4_6__ -DNDEBUG -D__GCCE__ -D__SYMBIAN_STDCPP_SUPPORT__ -include $EPOCINC/gcce/gcce.h -I$EPOCROOT/include -I$EPOCROOT/mkspecs/common/symbian -I$EPOCINC -I$EPOCINC/stdapis -I$EPOCINC/stdapis/sys -I$EPOCINC/stdapis/stlportv5 -I$EPOCINC/variant -I$EPOCINC/stdapis"
	
	download_extract ftp://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz nettle
	cd nettle-3.3
	CFLAGS=$SYSCFLAGS CPP=$SYSCFLAGS CC=arm-none-symbianelf-gcc ./configure --prefix=$HOME/out --host=arm-none-symbianelf --disable-shared || {
		cat config.log
		exit 1
	}
	make -j4 || {
		cat config.log
		exit 1
	}
}


set -e
set -x

$1;
