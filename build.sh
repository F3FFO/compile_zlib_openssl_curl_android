#!/bin/bash
export HOST_TAG=linux-x86_64
export MIN_SDK_VERSION=23
export NDK_ROOT=$1

if [ ! -d "$NDK_ROOT" ]; then
    echo "Please check NDK_ROOT directory"
    exit 1
fi

if [ -z "$NDK_ROOT" ]; then
    echo "Please set your NDK_ROOT environment variable first"
    exit 1
fi

if [[ "$NDK_ROOT" == .* ]]; then
    echo "Please set your NDK_ROOT to an absolute path"
    exit 1
fi

export TOOLCHAIN=$NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG

export CFLAGS="-Os"
export LDFLAGS="-Wl,-Bsymbolic"

chmod +x ./build-zlib.sh
chmod +x ./build-openssl.sh
chmod +x ./build-curl.sh

./build-zlib.sh
./build-openssl.sh
./build-curl.sh

exit 0
