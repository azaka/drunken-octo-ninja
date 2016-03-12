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

process_url() {
	in_file=$2
	url=$1
	
	aria2c -x 16 $url -o $in_file
	out_file=$in_file-x265.mp4
	ffmpeg -i $in_file -q -1 -s 640x360 -c:v libx265 $out_file
	stat $out_file
	chmod +x ./dropbox_uploader.sh
	[ -f ~/.dropbox_uploader ] && ./dropbox_uploader.sh upload $out_file travis-artifacts/$TRAVIS_JOB_NUMBER/
}

travis_script() {
	process_url https://lh3.googleusercontent.com/qZnxJDCDwDCRLzmm5cMKivJ1_bv_tC2SzTCoVY7IKkKYOeYEilcKOkh3POglCO19a5um=m22 w08
	process_url https://lh3.googleusercontent.com/aInhl-u-MJi6aMvA-t0DbWp8c2B6nM2uNKBUKBn-N0xJhUg6eRqL4ca-TAK_QZL4kaoQ=m22 b10
	process_url https://lh3.googleusercontent.com/BHBphBOgBIxabTuypGrb7nOhEP-G3w2XXT8Wv9ZtgpyQ7gMBPSbj6QthkagZkgEnLAPJ=m22 p10
	process_url https://lh3.googleusercontent.com/8v98E5eisFGh87KtppAGi28ByWaIMNIAJhJu0ZAW0EFMgwJYLsbXZdDrLHvkJcfriiKq=m22 v07
	process_url https://lh3.googleusercontent.com/_wDkMqBldx9FskesauwAa_CajH5CBCQgzvOyOQUgctS-BUkimw6as7X-_hFVnigYbRb9=m22 n12
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
