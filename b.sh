#!/bin/bash

#qmake CONFIG+=debug -spec symbian-sbsv2 test.pro
#make -j4 -w release-gcce

CROSS=arm-none-symbianelf
CC=$COMPILERROOT/bin/$CROSS-gcc
AR=$COMPILERROOT/bin/$CROSS-ar
RANLIB=$COMPILERROOT/bin/$CROSS-ranlib

EPOCINC=$EPOCROOT/epoc32/include
SYSCFLAGS="-march=armv6 -mapcs -mfpu=vfp -mfloat-abi=softfp -marm -DOPENSSL_NO_MD4 -D__SUPPORT_CPP_EXCEPTIONS__ -D_UNICODE -D__SYMBIAN32__ -D__EPOC32__ -D__MARM__ -D__EABI__ -DUNICODE -D__MARM_ARMV5__ -D__ARMV6__ -D__GCCE_4__ -D__GCCE_4_8__ -DNDEBUG -D__GCCE__ -D__SYMBIAN_STDCPP_SUPPORT__ -DSYMBIAN_ENABLE_SPLIT_HEADERS -D__XSI_VISIBLE -D__BSD_VISIBLE -DHAVE_LIBPTHREAD -include $EPOCINC/gcce/gcce.h -I$EPOCROOT/include -I$EPOCROOT/mkspecs/common/symbian -I$EPOCINC -I$EPOCINC/stdapis -I$EPOCINC/stdapis/sys -I$EPOCINC/stdapis/stlportv5 -I$EPOCINC/variant -I$EPOCINC/stdapis -include $EPOCINC/stdapis/openssl/opensslv.h"

EPOCLIB=$EPOCROOT/epoc32/release/armv5
LDFLAGS="-Wl,-rpath-link=$EPOCLIB/lib -L$EPOCLIB/lib -L$EPOCLIB/urel -L$COMPILERROOT/arm-none-symbianelf/lib -nostdlib \
-Wl,--target1-abs,--no-undefined -nodefaultlibs \
-Wl,-shared \
-Wl,-Ttext,0x80000,-Tdata,0x1000000 \
-Wl,--entry=_E32Startup -Wl,-u,_E32Startup \
-l:libpthread.dso \
-l:eexe.lib -l:usrt3_1.lib \
-l:libcrt0.lib -l:libstdcppv5.dso \
-l:libc.dso -l:libm.dso -l:euser.dso -l:stdnew.dso -l:drtaeabi.dso -l:dfpaeabi.dso -lsupc++ -lgcc \
-l:libz.dso -l:libssl.dso -l:libcrypto.dso -l:libdl.dso"

REPODIR=$(pwd)

cd $home
wget http://www.lua.org/ftp/lua-5.2.4.tar.gz
tar -zxf lua-5.2.4.tar.gz
LUADIR=lua-5.2.4
cd $LUADIR
EXTRA_CFLAGS="-DCLOCKS_PER_SEC=1000"
make ansi CC="$CC $SYSCFLAGS $EXTRA_CFLAGS" RANLIB=$RANLIB AR="$AR rcu"
make install INSTALL_TOP=$REPODIR/gcce/usr

