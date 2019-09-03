#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

BUILD_DIR="../build"

mkdir -p "${BUILD_DIR}/linux"
../tools/meson/meson.py ../libs/glib ${BUILD_DIR}/linux \
  -Dinternal_pcre=true \
  -Dc_args=-flto \
  -Ddefault_library=static
  ninja -C ${BUILD_DIR}/linux
  DESTDIR=install ninja -C ${BUILD_DIR}/linux install
