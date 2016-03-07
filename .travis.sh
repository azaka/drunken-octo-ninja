#/bin/bash

download_extract() {
	aria2c -x 16 $1 -o $2
	tar -xf $2
}

travis_before_install() {
	git submodule update --init --recursive
}

travis_install() {
	sudo add-apt-repository -y ppa:mc3man/trusty-media
	sudo apt-get update
	#sudo apt-get -y dist-upgrade
	sudo apt-get -y install aria2
	sudo apt-get -y install ffmpeg
}

travis_install2() {
	sudo apt-get update
	sudo apt-get -y install aria2
	sudo apt-get install lib32stdc++6 lib32bz2-1.0 -qq
	download_extract https://github.com/xsacha/SymbianGCC/releases/download/4.8.3/gcc4.8.3_x86-64.tar.bz2 compiler.tar.bz2
	download_extract https://github.com/xsacha/SymbianGCC/releases/download/4.8.3/ndk-new.tar.bz2 ndk.tar.bz2
	export EPOCROOT=$(pwd)/SDKs/SymbianSR1Qt474/ SBS_GCCE483BIN=$(pwd)/gcc4.8.3_x86-64/bin
	aria2c -x 16 https://github.com/hrydgard/ppsspp-ffmpeg/archive/master.zip -o master.zip
	unzip -qq master.zip
	ls
	mv ppsspp-ffmpeg-master ffmpeg
	cp ffmpeg/symbian/armv6/lib/* $EPOCROOT/epoc32/release/armv5/urel/
}

travis_script() {
	#aria2c -x 16 https://lh3.googleusercontent.com/yZSoa451q8rqxor5UU2dDTcFNgu4uC-HomfEUeabqWY=m22 -o b09
	#out_file=b09-x265.mp4
	in_file=n10
	url=https://lh3.googleusercontent.com/FfM5TAZ2YZis4PoPvqGnxwy6e0lGj5s8O_6IoU_gBVo=m22
	aria2c -x 16 $url -o $in_file
	out_file=$in_file-x265.mp4
	ffmpeg -i $in_file -q -1 -s 640x360 -c:v libx265 $out_file
	stat $out_file
	chmod +x ./dropbox_uploader.sh
	[ -f ~/.dropbox_uploader ] && ./dropbox_uploader.sh upload $out_file travis-artifacts/$TRAVIS_JOB_NUMBER/
}

travis_script2() {
	export EPOCROOT=$(pwd)/SDKs/SymbianSR1Qt474 COMPILERROOT=$(pwd)/gcc4.8.3_x86-64 
	export SBS_GCCE483BIN=$COMPILERROOT/bin
	PATH=$SBS_GCCE483BIN:$(pwd)/tools/sbs/bin:$EPOCROOT/epoc32/tools:$EPOCROOT/bin:$(pwd)/tools/sbs/linux-x86_64-libc2_15/bin:$PATH
	
	#chmod +x b.sh
	#./b.sh
	#chmod +x mingw.sh
	#./mingw.sh

}

set -e
set -x

$1;
