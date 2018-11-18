#/bin/bash

download_extract() {
	aria2c -x 16 $1 -o $2
	tar -xf $2
}

travis_before_install() {
	git submodule update --init --recursive
	python2 -c 'import os,sys,fcntl; flags = fcntl.fcntl(sys.stdout, fcntl.F_GETFL); fcntl.fcntl(sys.stdout, fcntl.F_SETFL, flags&~os.O_NONBLOCK);'
}

travis_install() {
	sudo apt-get update
	sudo apt-get -y install aria2
	
	sudo apt-get install lib32stdc++6 lib32bz2-1.0 -qq
	download_extract https://github.com/xsacha/SymbianGCC/releases/download/4.8.3/gcc4.8.3_x86-64.tar.bz2 compiler.tar.bz2
	download_extract https://github.com/xsacha/SymbianGCC/releases/download/4.8.3/ndk-new.tar.bz2 ndk.tar.bz2
	export EPOCROOT=$(pwd)/SDKs/SymbianSR1Qt474/ SBS_GCCE483BIN=$(pwd)/gcc4.8.3_x86-64/bin
	
	cp $EPOCROOT/epoc32/release/armv5/lib/libm.dso $EPOCROOT/epoc32/release/armv5/lib/libm.a
}

travis_script() {
	export EPOCROOT=$(pwd)/SDKs/SymbianSR1Qt474/
	export COMPILERROOT=$(pwd)/gcc4.8.3_x86-64
	chmod +x b.sh
	./b.sh

	cd $TRAVIS_BUILD_DIR
	git clone --depth 1 https://github.com/termux/x11-packages
	cd  x11-packages
	export TERMUX_X11_BUILD_ROOT=$(pwd)
	$TERMUX_X11_BUILD_ROOT/scripts/travis-build.sh || true

	cd termux-packages
	export TERMUX_BUILD_ROOT=$(pwd)

	# restore build artifacts from private container image
	docker login -u azaka -p $QUAY_PASSWORD quay.io
	artifacts_container=$(docker create quay.io/azaka/x11-data)
	docker cp $artifacts_container:/home/sam/data.tar $TERMUX_BUILD_ROOT
	$TERMUX_BUILD_ROOT/scripts/run-docker.sh tar xf data.tar -C /

	# test packages
	tar xf $TRAVIS_BUILD_DIR/packages.tar.xz -C $TERMUX_BUILD_ROOT

	# package already built
	$TERMUX_BUILD_ROOT/scripts/run-docker.sh ./build-package.sh gtk2
	export TERMUX_BUILD_OPTS=-q

	# setup gnu c compiler
	cd $TERMUX_BUILD_ROOT
	wget https://dl.google.com/android/repository/android-ndk-r17b-Linux-x86_64.zip
	unzip -q $TERMUX_BUILD_ROOT/android-ndk-r17b-Linux-x86_64.zip
	rm $TERMUX_BUILD_ROOT/android-ndk-r17b-Linux-x86_64.zip
	export NDK=$TERMUX_BUILD_ROOT/android-ndk-r17b
	export TOOLCHAIN=$TERMUX_BUILD_ROOT/toolchain
	$NDK/build/tools/make_standalone_toolchain.py --api 21 --arch arm64 --stl=gnustl --install-dir $TOOLCHAIN

	# fix linker errors
	cp $TOOLCHAIN/aarch64-linux-android/bin/ld.gold $TOOLCHAIN/aarch64-linux-android/bin/ld


	cd $TRAVIS_BUILD_DIR
	chmod +x build-opengapps.sh
	# ./build-opengapps.sh
	
	chmod +x build-vita3k.sh
	# ./build-vita3k.sh
	
	chmod +x build-webxoss.sh
	./build-webxoss.sh
	
	chmod +x vgmstream-build.sh
	./vgmstream-build.sh
	
	cd $TRAVIS_BUILD_DIR
	wget https://github.com/devkitPro/pacman/releases/download/devkitpro-pacman-1.0.1/devkitpro-pacman.deb && \
	sudo dpkg -i devkitpro-pacman.deb && \
	export DEVKITPRO=/opt/devkitpro && \
	sudo dkp-pacman -S devkitA64 devkitpro-pkgbuild-helpers --noconfirm
	
	cd $TRAVIS_BUILD_DIR
	./mahjong-build.sh
}


set -e
set -x

$1;
