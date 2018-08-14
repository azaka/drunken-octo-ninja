#! /bin/sh -e

cd $TRAVIS_BUILD_DIR
git clone https://github.com/webxoss/webxoss-core --depth 1
cd webxoss-core
git submodule update --init --recursive
cd webxoss-client
curl https://webxoss.com/images.tar | tar x
cd -
npm install
cd $TRAVIS_BUILD_DIR
