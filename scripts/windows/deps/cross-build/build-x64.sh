#!/bin/bash

pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
pushd $SCRIPT_DIR/../../../.. >/dev/null
export ROOT_DIR=`pwd -P`
export INSTALL_PREFIX=$ROOT_DIR/ossim-deps
popd >/dev/null
popd >/dev/null

pushd $ROOT_DIR/ffmpeg-2.8.1 >/dev/null


./configure --prefix=$INSTALL_PREFIX --arch=x86_64 --target-os=mingw32 --cross-prefix=x86_64-w64-mingw32- --disable-yasm --enable-shared --disable-static
RETURN_CODE=$?
if [ $RETURN_CODE -ne 0 ];then
    echo "CONFIGURE ERROR: ffmpeg failed to configure..."
   exit 1
else
    RETURN_CODE=0;
fi
make -j4 
RETURN_CODE=$?
if [ $RETURN_CODE -ne 0 ];then
    echo "MAKE ERROR: ffmpeg failed to build..."
   exit 1
else
    RETURN_CODE=0;
fi

make install
RETURN_CODE=$?
if [ $RETURN_CODE -ne 0 ];then
    echo "MAKE INSTALL ERROR: ffmpeg failed to install..."
   exit 1
else
    RETURN_CODE=0;
fi

mv $INSTALL_PREFIX/bin/*.lib $INSTALL_PREFIX/lib/

popd >/dev/null


exit $RETURN_CODE
