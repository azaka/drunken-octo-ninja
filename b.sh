#!/bin/bash

#qmake CONFIG+=debug -spec symbian-sbsv2 test.pro
#make -j4 -w release-gcce

CROSS=arm-none-symbianelf
CC=$COMPILERROOT/bin/$CROSS-gcc
AR=$COMPILERROOT/bin/$CROSS-ar
RANLIB=$COMPILERROOT/bin/$CROSS-ranlib

EPOCINC=$EPOCROOT/epoc32/include
SYSCFLAGS="-march=armv6 -mapcs -mfpu=vfp -mfloat-abi=softfp -marm -D__SUPPORT_CPP_EXCEPTIONS__ -D_UNICODE -D__SYMBIAN32__ -D__EPOC32__ -D__MARM__ -D__EABI__ '-D__PRODUCT_INCLUDE__="\"$EPOCINC/variant/platform_paths.hrh\""' -DUNICODE -D__MARM_ARMV5__ -D__ARMV6__ -D__GCCE_4__ -D__GCCE_4_6__ -DNDEBUG -D__GCCE__ -D__SYMBIAN_STDCPP_SUPPORT__ -include $EPOCINC/gcce/gcce.h -I$EPOCROOT/include -I$EPOCROOT/mkspecs/common/symbian -I$EPOCINC -I$EPOCINC/stdapis -I$EPOCINC/stdapis/sys -I$EPOCINC/stdapis/stlportv5 -I$EPOCINC/variant -I$EPOCINC/stdapis"

REPODIR=$(pwd)

cd $home
wget http://www.lua.org/ftp/lua-5.2.4.tar.gz
tar -zxf lua-5.2.4.tar.gz
LUADIR=lua-5.2.4/src
cd $LUADIR

EXTRA_CFLAGS="-DCLOCKS_PER_SEC=1000"
make ansi ALL=a CC="$CC $SYSCFLAGS $EXTRA_CFLAGS" RANLIB=$RANLIB AR="$AR rcu"
sudo cp liblua.a $REPO/lua.lib

cd $home
ls
git clone --branch=master git://github.com/fluorohydride/ygopro-core ygopro-core
cd ygopro-core
git checkout -b v1337 fadb219
git checkout -b build e8420f
git apply $REPODIR/patch
git commit -am"patch"
git merge v1337
git revert 99e817 -m"revert"
EXTRA_CFLAGS='-DBOOST_COMPILER_CONFIG="\"boost/mpl/aux_/config/gcc.hpp\""'
$CC $SYSCFLAGS -c *.cpp -I$LUADIR -O2 -fpermissive -std=c++11
$AR rcu ocgcore.lib *.o
sudo cp ocgcore.lib $REPO/ocgcore.lib
