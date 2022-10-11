#!/bin/bash
if [ -f /proc/cpuinfo ]; then
        JOBS=$(grep flags /proc/cpuinfo | wc -l)
elif [ ! -z $(which sysctl) ]; then
        JOBS=$(sysctl -n hw.ncpu)
else
        JOBS=2
fi

mkdir -p ./build/zlib
export BUILD_FOLDER=$PWD/build/zlib
cd zlib

export AR=$TOOLCHAIN/bin/llvm-ar
export TARGET_HOST=(aarch64-linux-android armv7a-linux-androideabi x86_64-linux-android i686-linux-android)
export ANDROID_ARCH=(arm64-v8a armeabi-v7a x86_64 x86)
index=0

for target in ${TARGET_HOST[*]}; do
        export CC=$TOOLCHAIN/bin/$target$MIN_SDK_VERSION-clang
        export prefix=$BUILD_FOLDER/${ANDROID_ARCH[index]}

        ./configure \
                --static

        make -j$JOBS
        make install
        make clean
        index=$(($index + 1))
done

cd ..
