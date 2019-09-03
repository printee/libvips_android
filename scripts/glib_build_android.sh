#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

NDK=~/Android/Sdk/ndk-bundle
HOST_TAG=linux-x86_64
BUILD_DIR="../build"

function build_for_arch() {
	if ! test -e ${BUILD_DIR}/${1}/install/usr/local/lib/libglib-2.0.a; then
		cross_file="${BUILD_DIR}/${1}/cross_file.txt"
		TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
		mkdir -p ${BUILD_DIR}/${1}
		cat << EOF > "${cross_file}"
[host_machine]
system = 'android'
cpu_family = '${4}'
cpu = '${5}'
endian = 'little'

[properties]
c_args = []
c_link_args = []

[binaries]
c = '$TOOLCHAIN/bin/${1}${2}-clang'
cpp = '$TOOLCHAIN/bin/${1}${2}-clang++'
ar = '$TOOLCHAIN/bin/${3}-ar'
strip = '$TOOLCHAIN/bin/${1}-strip'
ranlib = '$TOOLCHAIN/bin/${1}-ranlib'
ld = '$TOOLCHAIN/bin/${1}-ld'
pkgconfig = '$TOOLCHAIN/lib/pkgconfig'
EOF

#c_args = ['-flto']
#c_link_args = ['-flto']

../tools/meson/meson.py ../libs/glib ${BUILD_DIR}/${1} --cross-file "${cross_file}" \
	-Dinternal_pcre=true \
	-Ddefault_library=static
ninja -C ${BUILD_DIR}/${1}
DESTDIR=install ninja -C ${BUILD_DIR}/${1} install
fi
}

build_for_arch armv7a-linux-androideabi 16 arm-linux-androideabi arm armv7a
build_for_arch aarch64-linux-android 21 aarch64-linux-android aarch64 aarch64
build_for_arch i686-linux-android 16 i686-linux-android x86 i686
build_for_arch x86_64-linux-android 21 x86_64-linux-android x86_64 x86_64
