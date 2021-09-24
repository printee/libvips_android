#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

source ../ndk_paths.sh
TOOLCHAIN="clang"
INSTALL_DIR="$(pwd)/../build"
PATH_TO_LIBJPEG_TURBO="../libs/libjpeg-turbo/"

cd ${PATH_TO_LIBJPEG_TURBO}

function build_for_arch() {
	INSTALL_LOC="${INSTALL_DIR}/${1}/install/usr/local"
	if ! test -e "${INSTALL_LOC}/lib/libjpeg.a"; then
		mkdir -p build/${1}
		cd build/${1}
		#export CFLAGS="$CFLAGS -fPIC -Os -flto"
		export CFLAGS="$CFLAGS -fPIC"
		cmake -G"Unix Makefiles" \
			-DANDROID_ABI=${3} ${4}\
			-DANDROID_PLATFORM=android-${2} \
			-DANDROID_TOOLCHAIN=${TOOLCHAIN} \
			-DCMAKE_ASM_FLAGS="--target=${1}${2}" \
			-DCMAKE_TOOLCHAIN_FILE=${NDK}/build/cmake/android.toolchain.cmake \
			-DCMAKE_INSTALL_PREFIX=${INSTALL_LOC} \
			-DENABLE_SHARED=0 \
			-DENABLE_STATIC=1 \
			../../
		make -j4
		make install
		cd ../..
	fi
}

build_for_arch armv7a-linux-androideabi 21 armeabi-v7a "-DANDROID_ARM_MODE=arm"
build_for_arch aarch64-linux-android 21 arm64-v8a "-DANDROID_ARM_MODE=arm"
build_for_arch i686-linux-android 21 x86 ""
build_for_arch x86_64-linux-android 21 x86_64 ""
