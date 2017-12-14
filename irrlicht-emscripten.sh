#/bin/bash

cd $HOME
sudo apt-get install emscripten
emcc -v
wget https://github.com/cjrgames/emscripten/archive/master.zip && \
unzip -q master && \
cd emscripten-master/irrlicht-ogl-es && \
make -j7 irrlicht
cd irrlicht/examples/01.HelloWorld
emmake make -f Makefile.emscripten
