#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

INSTALL_FOLDER="$(pwd)/../build"

cd "../libs/libexif"

if ! test -e configure; then
  # on ubuntu derivatives install with: sudo apt-get install autoconf libtool autopoint
  autoreconf -i
fi

export CFLAGS="$CFLAGS -fPIC -Os -flto"
./configure "--prefix=${INSTALL_FOLDER}/linux/install/usr/local" \
  --disable-shared \
  --enable-static
  make -j4
  make install
  make distclean
