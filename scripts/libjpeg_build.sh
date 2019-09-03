#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1


INSTALL_DIR="$(pwd)/../build"
PATH_TO_LIBJPEG_TURBO="../libs/libjpeg-turbo/"

cd ${PATH_TO_LIBJPEG_TURBO}

rm -r build/linux
mkdir -p build/linux
cd build/linux
export CFLAGS="$CFLAGS -fPIC -Os -flto"
cmake -G"Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/linux/install/usr/local \
  -DENABLE_SHARED=0 \
  -DENABLE_STATIC=1 \
  ../../
make -j4
make install
