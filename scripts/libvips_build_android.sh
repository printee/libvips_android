#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1


INSTALL_DIR="$(pwd)/../build"

# Deleting *.la files is needed so there is no absolute RPATH dependency on libheif.so
# which would then fail to load on android devices
#
# The libheif.so dependency should be as below:
# readelf -d ./build/aarch64-linux-android/install/usr/local/lib/libvips.so |grep NEEDED
# 0x0000000000000001 (NEEDED)             Shared library: [libheif.so]
#
#
find "$INSTALL_DIR" -name "*.la" -exec rm {} \;

cd "../libs/libvips"

function build_for_arch() {
	fake_sysroot=${INSTALL_DIR}/${1}/install
	if ! test -e "${fake_sysroot}/usr/local/lib/libvips.so"; then
		#export CFLAGS="$CFLAGS -fPIC -O2 -flto"
		export CFLAGS="$CFLAGS -fPIC -O2"
		local_cflags="$CFLAGS"
                if [[ ${3} == "aarch64-linux-android" ]]
		then
			local_cflags="$CFLAGS -mno-outline-atomics"
		fi
                export TARGET=${1}
                export API=${2}
                export ABI=${3}
                source ../../ndk_paths.sh
		export PKG_CONFIG_DIR=
		export PKG_CONFIG_LIBDIR=${fake_sysroot}/usr/local/lib/pkgconfig
		export PKG_CONFIG_SYSROOT_DIR=${fake_sysroot}
		export PKG_CONFIG_PATH=${fake_sysroot}/usr/local/lib/pkgconfig
		#export LIBS="-lde265"
		#--disable-shared \
			#--enable-static \
		CFLAGS="${local_cflags}" \
			./configure \
			--disable-static --enable-shared \
			"--prefix=${fake_sysroot}/usr/local" \
			"--with-sysroot=${NDK}/sysroot" \
			--host ${1} \
			"--with-expat=${fake_sysroot}/usr/local" \
			"--with-zlib=${NDK}/sysroot" \
			"--with-png-includes=${fake_sysroot}/usr/local/include" \
			"--with-png-libraries=${fake_sysroot}/usr/local/libs" \
			"--with-heif=${fake_sysroot}/usr/local" \
			"--with-libwebp=${fake_sysroot}/usr/local" \
			--without-gsf \
			--without-fftw \
			--without-magick \
			--without-orc \
			--without-lcms \
			--without-OpenEXR \
			--without-nifti \
			--without-pdfium \
			--without-poppler \
			--without-rsvg \
			--without-openslide \
			--without-matio \
			--without-ppm \
			--without-analyze \
			--without-radiance \
			--without-cfitsio \
			--without-pangoft2 \
			--without-tiff \
			--without-giflib \
			--without-imagequant \

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
