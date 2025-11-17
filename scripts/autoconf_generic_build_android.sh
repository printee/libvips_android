#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

INSTALL_FOLDER="$(pwd)/../build"
CONFIGURE_PARAMS="${2}"
LIBRARY_NAME="${1}"

cd "../libs/${LIBRARY_NAME}"

if ! test -e configure; then
	# on ubuntu derivatives install with: sudo apt-get install autoconf libtool autopoint
	autoreconf -i
fi

function build_for_arch() {
	INSTALL_LOC="${INSTALL_FOLDER}/${1}/install/usr/local"
	if ! test -e "${INSTALL_LOC}/lib/${LIBRARY_NAME}.a"; then
	if ! test -e "${INSTALL_LOC}/lib/${LIBRARY_NAME}.so"; then
		export TARGET=${1}
		export API=${2}
		export ABI=${3}
		source ../../ndk_paths.sh
		export CFLAGS="$CFLAGS -fPIC -O3"
		#export CFLAGS="$CFLAGS -fPIC -O3 -flto"
		export CXXFLAGS="$CXXFLAGS -fPIC -O3"
		local_cflags="$CFLAGS"
		local_cxxflags="$CXXFLAGS"
		if [[ ${3} == "aarch64-linux-android" ]]
                then
                        local_cflags="$CFLAGS -mno-outline-atomics"
                        local_cxxflags="$CXXFLAGS -mno-outline-atomics"
                fi
		export PKG_CONFIG_DIR=
                export PKG_CONFIG_LIBDIR=${INSTALL_LOC}/lib/pkgconfig
                export PKG_CONFIG_PATH=${INSTALL_LOC}/lib/pkgconfig
		CFLAGS="${local_cflags}" \
			CXXFLAGS="${local_cxxflags}" \
			./configure \
			"--prefix=${INSTALL_LOC}" --host ${1} \
			${CONFIGURE_PARAMS}
		make -j4
		mkdir -p build/${1}
		make install
		make distclean
	fi
	fi
}

build_for_arch armv7a-linux-androideabi 21 arm-linux-androideabi
build_for_arch aarch64-linux-android 21 aarch64-linux-android
build_for_arch i686-linux-android 21 i686-linux-android
build_for_arch x86_64-linux-android 21 x86_64-linux-android
