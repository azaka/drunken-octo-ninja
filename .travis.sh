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
}

travis_script() {
	download_extract ftp://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz nettle
	cd nettle-3.3
	./configure --prefix=$HOMW/out
	make -j4
}


set -e
set -x

$1;
