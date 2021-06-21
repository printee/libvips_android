#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

./tools/fetch_all.sh
./libs/fetch_all.sh
cd scripts
./gettext_tiny_build_android.sh
#./libintl_lite_build_android.sh
./glib_build_android.sh
./autoconf_generic_build_android.sh libexpat
./autoconf_generic_build_android.sh libexif
./libjpeg_build_android.sh
./libpng_build_android.sh
CFLAGS=-fno-integrated-as ./autoconf_generic_build_android.sh libde265 "--disable-dec265 --disable-sherlock265"
./autoconf_generic_build_android.sh libheif "--disable-go --disable-examples --disable-aom --disable-x265 --disable-gdk-pixbuf --disable-rav1e"
./libvips_build_android.sh
#./missing_symbols_fix_build_android.sh
