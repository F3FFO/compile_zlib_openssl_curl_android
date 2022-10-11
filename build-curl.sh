#!/bin/bash
if [ -f /proc/cpuinfo ]; then
    JOBS=$(grep flags /proc/cpuinfo | wc -l)
elif [ ! -z $(which sysctl) ]; then
    JOBS=$(sysctl -n hw.ncpu)
else
    JOBS=2
fi

ARGUMENTS=" \
    --disable-ftp --disable-gopher \
    --disable-file --disable-imap \
    --disable-ldap --disable-ldaps \
    --disable-pop3 --disable-proxy \
    --disable-rtsp --disable-smtp \
    --disable-telnet --disable-tftp \
    --without-gnutls --without-libidn \
    --without-librtmp --disable-dict"

export INCLUDE_ROOT=$PWD/build/include
export LIB_ROOT=$PWD/build/lib

export SSL_ROOT=$PWD/build/openssl
export ZLIB_ROOT=$PWD/build/zlib
mkdir -p ./build/curl
export BUILD_FOLDER=$PWD/build/curl
cd curl
autoreconf -fi

export AS=$TOOLCHAIN/bin/llvm-as
export AR=$TOOLCHAIN/bin/llvm-ar
export NM=$TOOLCHAIN/bin/llvm-nm
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip
#export LIBS="-lssl -lcrypto"
export TARGET_HOST=(aarch64-linux-android armv7a-linux-androideabi x86_64-linux-android i686-linux-android)
export ANDROID_ARCH=(arm64-v8a armeabi-v7a x86_64 x86)
index=0

for target in ${TARGET_HOST[*]}; do
    export CC=$TOOLCHAIN/bin/$target$MIN_SDK_VERSION-clang
    export CXX=$TOOLCHAIN/bin/$target$MIN_SDK_VERSION-clang++
    export SSL_PATH=$SSL_ROOT/${ANDROID_ARCH[index]}
    export ZLIB_PATH=$ZLIB_ROOT/${ANDROID_ARCH[index]}

    mkdir -p $BUILD_FOLDER/${ANDROID_ARCH[index]}

    ./configure \
        --host=$target \
        --target=$target \
        --prefix=$BUILD_FOLDER/${ANDROID_ARCH[index]} \
        --with-ssl=$SSL_PATH --with-zlib=$ZLIB_PATH $ARGUMENTS

    make -j$JOBS
    make install
    make clean
    index=$(($index + 1))
done

cd ..
