#!/bin/bash

qmake CONFIG+=debug -spec symbian-sbsv2 test.pro
make -j4 -w release-gcce

cd $home
git clone --depth=50 --branch=master git://github.com/WagicProject/wagic.git wagic
cd wagic/projects/mtg
ls

qmake DEFINES+=USE_PHONON QT+=phonon -spec symbian-sbsv2 wagic-qt.pro
cat Makefile.Graphics
grep -nr release-gcce Makefile.Graphics
#make -j4 -w -f Makefile.Graphics release-gcce
