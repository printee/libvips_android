#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

NDK=~/Android/Sdk/ndk-bundle
HOST_TAG=linux-x86_64
INSTALL_DIR="$(pwd)/build"

function build_for_arch() {

	SR=${INSTALL_DIR}/${1}/install
	LP=${SR}/usr/local/lib/

	export CFLAGS="$CFLAGS -fPIC -O2 -flto"
	export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
	export AR=$TOOLCHAIN/bin/${3}-ar
	export AS=$TOOLCHAIN/bin/${3}-as
	export CC=$TOOLCHAIN/bin/${1}${2}-clang
	export CXX=$TOOLCHAIN/bin/${1}${2}-clang++
	export LD=$TOOLCHAIN/bin/${3}-ld
	export RANLIB=$TOOLCHAIN/bin/${3}-ranlib
	export STRIP=$TOOLCHAIN/bin/${3}-strip
	export PKG_CONFIG_DIR=
	export PKG_CONFIG_LIBDIR=${fake_sysroot}/usr/lib/pkgconfig:${fake_sysroot}/usr/share/pkgconfig
	export PKG_CONFIG_SYSROOT_DIR=${fake_sysroot}
	export PKG_CONFIG_PATH=${fake_sysroot}/usr/local/lib/pkgconfig

	out_file=${INSTALL_DIR}/${1}/resize

	$CC \
		-o $out_file \
		-O2 \
		-Wl,--as-needed \
		-Wl,--gc-sections \
		-flto \
		-I${SR}/usr/local/include \
		-I${SR}/usr/local/include \
		-I${SR}/usr/local/include/glib-2.0 \
		-I${SR}/usr/local/lib/glib-2.0/include \
		resize.c \
		${LP}/libvips.a \
		-lm \
		-pthread \
		${LP}/libgmodule-2.0.a \
		${LP}/libgobject-2.0.a \
		${LP}/libffi.a \
		${LP}/libexif.a \
		${LP}/libexpat.a \
		${LP}/libjpeg.a \
		${LP}/libpng.a \
		${LP}/libglib-2.0.a \
		-lz \
		-ldl \

		$STRIP -s $out_file
}




build_for_arch armv7a-linux-androideabi 16 arm-linux-androideabi
#build_for_arch aarch64-linux-android 21 aarch64-linux-android
#build_for_arch i686-linux-android 16 i686-linux-android
#build_for_arch x86_64-linux-android 21 x86_64-linux-android
