#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

NDK=~/Android/Sdk/ndk-bundle
HOST_TAG=linux-x86_64
INSTALL_FOLDER="$(pwd)/../build"

cd "../libs/libexif"

if ! test -e configure; then
	# on ubuntu derivatives install with: sudo apt-get install autoconf libtool autopoint
	autoreconf -i
fi

function build_for_arch() {
	if ! test -e build/${1}; then
		export CFLAGS="$CFLAGS -fPIC -O3"
		#export CFLAGS="$CFLAGS -fPIC -O3 -flto"
		export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
		export AR=$TOOLCHAIN/bin/${3}-ar
		export AS=$TOOLCHAIN/bin/${3}-as
		export CC=$TOOLCHAIN/bin/${1}${2}-clang
		export CXX=$TOOLCHAIN/bin/${1}${2}-clang++
		export LD=$TOOLCHAIN/bin/${3}-ld
		export RANLIB=$TOOLCHAIN/bin/${3}-ranlib
		export STRIP=$TOOLCHAIN/bin/${3}-strip
		./configure "--prefix=${INSTALL_FOLDER}/${1}/install/usr/local" --host ${1} \
			--disable-shared \
			--enable-static
		make -j4
		mkdir -p build/${1}
		make install
		make distclean
	fi
}

build_for_arch armv7a-linux-androideabi 16 arm-linux-androideabi
build_for_arch aarch64-linux-android 21 aarch64-linux-android
build_for_arch i686-linux-android 16 i686-linux-android
build_for_arch x86_64-linux-android 21 x86_64-linux-android
