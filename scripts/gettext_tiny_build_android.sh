#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

INSTALL_FOLDER="$(pwd)/../build"

cd "../libs/gettext-tiny"

function build_for_arch() {
	out_root="${INSTALL_FOLDER}/${1}/install/usr/local"
	out_library="${out_root}/lib/libintl.so"
	if ! test -e "${out_library}"; then
		mkdir -p "${out_root}/"{lib,include}
		export TARGET=${1}
                export API=${2}
                export ABI=${3}
		source ../../ndk_paths.sh
		"$CC" -fPIC -O3 -shared -o "${out_library}" libintl/libintl.c
		cp include/libintl.h "${out_root}/include/"
		echo "**** Build and install of noop libintl for ${1} finished :):):) ****"
	fi
}

build_for_arch armv7a-linux-androideabi 21 arm-linux-androideabi
build_for_arch aarch64-linux-android 21 aarch64-linux-android
build_for_arch i686-linux-android 21 i686-linux-android
build_for_arch x86_64-linux-android 21 x86_64-linux-android
