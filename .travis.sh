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
	
	cp $EPOCROOT/epoc32/release/armv5/lib/libm.dso $EPOCROOT/epoc32/release/armv5/lib/libm.a
}

travis_script() {
	export EPOCROOT=$(pwd)/SDKs/SymbianSR1Qt474/
	export COMPILERROOT=$(pwd)/gcc4.8.3_x86-64
	chmod +x b.sh
	./b.sh
	
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
