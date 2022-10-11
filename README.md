# Compile zlib, OpenSSL & cUrl for Android

Compile zlib, OpenSSL and cUrl for Android

## Prerequisites

Make sure you have [Android NDK](https://developer.android.com/studio/projects/install-ndk) installed.

You may also need to install `autoconf` and `libtool` toolchains as well as build essentials.

## Download

If you do not want to compile them yourself, you can download pre-compiled static libraries from [releases](https://github.com/F3FFO/compile_curl_openssl_android/releases).

Checkout newer versions in git submodules to compile newer versions of the libraries.
For example, to build:

- ### `zlib v1.2.12`

```bash
cd zlib
git fetch
git checkout tags/v1.2.12
cd ..
```

- ### `OpenSSL 1_1_1q`

```bash
cd openssl
git fetch
git checkout OpenSSL_1_1_1q
cd ..
```

- ### `cUrl 7_85_0`

```bash
cd curl
git fetch
git checkout curl-7_85_0
cd ..
```

## Usage

```bash
git clone https://github.com/F3FFO/compile_zlib_openssl_curl_android.git
cd compile_zlib_openssl_curl_android
git submodule update --init --recursive

export NDK=<your_android_ndk_root_here> # e.g. $HOME/Library/Android/sdk/ndk/25.1.8937393
export HOST_TAG=<your_host_tag> # e.g. linux-x86_64, see https://developer.android.com/ndk/guides/other_build_systems#overview
export MIN_SDK_VERSION=23 # or any version you want, see https://apilevels.com/

chmod +x ./build.sh
./build.sh
```

All compiled libs are located in `build/` directory.

Use NDK to link those libs, part of `Android.mk` example:

```makefile
LOCAL_PATH := $(call my-dir)/..

CURL_COMMON_CFLAGS := \
	-Wpointer-arith -Wwrite-strings -Wunused -Winline \
	-Wnested-externs -Wmissing-declarations -Wmissing-prototypes -Wno-long-long \
	-Wfloat-equal -Wno-multichar -Wsign-compare -Wno-format-nonliteral \
	-Wendif-labels -Wstrict-prototypes -Wdeclaration-after-statement -Wno-system-headers \
	-DHAVE_CONFIG_H

include $(CLEAR_VARS)
LOCAL_MODULE := curl
LOCAL_MODULE_TAGS := optional
LOCAL_EXPORT_C_INCLUDES += $(LOCAL_PATH)/build/curl/$(TARGET_ARCH_ABI)/include/curl/
LOCAL_SRC_FILES := $(LOCAL_PATH)/build/curl/$(TARGET_ARCH_ABI)/lib/libcurl.a
LOCAL_CFLAGS += $(CURL_COMMON_CFLAGS)
include $(PREBUILT_STATIC_LIBRARY)
```

If you do not want to compile the binaries on your own, you can refer to this repository: https://github.com/Zackptg5/Cross-Compiled-Binaries-Android
