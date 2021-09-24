#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1


INSTALL_DIR="$(pwd)/../build"

cd "../libs/libpng"

# fix broken configure script in some libpng releases (windows line endings?, /bin/sh{EVIL SIGN} : bad interpreter
for f in \
	configure \
	config.sub \
	config.guess \
	scripts/options.awk \
	scripts/dfn.awk \
	pngconf.h \
	scripts/pnglibconf.dfa\
	pngusr.dfa \
	depcomp \
	ltmain.sh \
	missing \
#	config.status \

do
	sed -i -e 's/\r$//' "${f}"
done

function build_for_arch() {
	INSTALL_LOC="${INSTALL_DIR}/${1}/install/usr/local"
	if ! test -e "${INSTALL_LOC}/lib/libpng.a"; then
		#export CFLAGS="$CFLAGS -fPIC -O2 -flto"
		export CFLAGS="$CFLAGS -fPIC"
		export TARGET=${1}
                export API=${2}
                export ABI=${3}
                source ../../ndk_paths.sh
		./configure "--prefix=${INSTALL_LOC}" --host ${1} \
			--disable-shared \
			--enable-static
		make -j4
		mkdir -p build/${1}
		make install
		make distclean
	fi
}

build_for_arch armv7a-linux-androideabi 21 arm-linux-androideabi
build_for_arch aarch64-linux-android 21 aarch64-linux-android
build_for_arch i686-linux-android 21 i686-linux-android
build_for_arch x86_64-linux-android 21 x86_64-linux-android
