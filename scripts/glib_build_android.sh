#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

BUILD_DIR="$(pwd)/../build"

function build_for_arch() {
	if ! test -e ${BUILD_DIR}/${1}/install/usr/local/lib/libglib-2.0.a; then
		fake_root="${BUILD_DIR}/${1}/install/usr/local"
		cross_file="${BUILD_DIR}/${1}/cross_file.txt"
		export TARGET=${1}
                export API=${2}
                export ABI=${3}
                source ../ndk_path_only.sh
		mkdir -p ${BUILD_DIR}/${1}
		cat << EOF > "${cross_file}"
[host_machine]
system = 'android'
cpu_family = '${4}'
cpu = '${5}'
endian = 'little'

[properties]
c_args = ['-I${fake_root}/include', '-Wno-error=format-nonliteral']
c_link_args = ['-L${fake_root}/lib']

[binaries]
c = '$TOOLCHAIN/bin/${1}${2}-clang'
cpp = '$TOOLCHAIN/bin/${1}${2}-clang++'
ar = '$TOOLCHAIN/bin/llvm-ar'
strip = '$TOOLCHAIN/bin/llvm-strip'
ranlib = '$TOOLCHAIN/bin/llvm-ranlib'
ld = '$TOOLCHAIN/bin/${1}${2}-clang'
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

build_for_arch armv7a-linux-androideabi 21 arm-linux-androideabi arm armv7a
build_for_arch aarch64-linux-android 21 aarch64-linux-android aarch64 aarch64
build_for_arch i686-linux-android 21 i686-linux-android x86 i686
build_for_arch x86_64-linux-android 21 x86_64-linux-android x86_64 x86_64
