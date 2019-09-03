#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1


INSTALL_DIR="$(pwd)/../build"

cd "../libs/libvips"

fake_sysroot=${INSTALL_DIR}/linux/install
export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR=${fake_sysroot}/usr/local/lib/pkgconfig
export PKG_CONFIG_SYSROOT_DIR=${fake_sysroot}
export PKG_CONFIG_PATH=${fake_sysroot}/usr/local/lib/pkgconfig
export CFLAGS="$CFLAGS -I${fake_sysroot}/include -I${fake_sysroot}/usr/local/include/glib-2.0 -I${fake_sysroot}/usr/local/lib/glib-2.0/include -fPIC -Os -flto -L${fake_sysroot}/lib64 -L${fake_sysroot}/lib"
./configure \
  --disable-shared \
  --enable-static \
  "--prefix=${fake_sysroot}/usr/local" \
  "--with-sysroot=${fake_sysroot}" \
  "--with-expat=${fake_sysroot}/usr/local" \
  "--with-png=${fake_sysroot}/usr/local" \
  "--with-jpeg-includes=${fake_sysroot}/usr/local/include" \
  "--with-jpeg-libraries=${fake_sysroot}/usr/local/lib64" \
  --without-zlib \
  --without-gsf \
  --without-fftw \
  --without-magick \
  --without-orc \
  --without-lcms \
  --without-OpenEXR \
  --without-nifti \
  --without-heif \
  --without-pdfium \
  --without-poppler \
  --without-rsvg \
  --without-openslide \
  --without-matio \
  --without-ppm \
  --without-analyze \
  --without-radiance \
  --without-cfitsio \
  --without-libwebp \
  --without-pangoft2 \
  --without-tiff \
  --without-giflib \
  --without-imagequant \

make -j4
make install
make distclean
