#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

# setup dependencies and old python version on newer ubuntu machines:
# sudo apt install autoconf automake libtool build-essential autopoint cmake
# sudo apt install zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev liblzma-dev tk-dev libgdbm-dev libnss3-dev uuid-dev
# curl https://pyenv.run | bash
# export pyenv to PATH in .bashrc and open new shell
# pyenv install 3.11.8
# pyenv global 3.11.8

./tools/fetch_all.sh
./libs/fetch_all.sh
cd scripts
./gettext_tiny_build_android.sh
#./libintl_lite_build_android.sh
./glib_build_android.sh
./autoconf_generic_build_android.sh libexpat "--disable-shared --enable-static"
./autoconf_generic_build_android.sh libexif "--disable-shared --enable-static"
./libjpeg_build_android.sh
./libpng_build_android.sh
#CFLAGS=-fno-integrated-as ./autoconf_generic_build_android.sh libde265 "--disable-shared --enable-static --disable-dec265 --disable-sherlock265"
./autoconf_generic_build_android.sh libde265 "--disable-shared --enable-static --disable-dec265 --disable-sherlock265 --disable-arm"
#CFLAGS=-mfpu=neon ./autoconf_generic_build_android.sh libde265 "--disable-dec265 --disable-sherlock265"
./autoconf_generic_build_android.sh libheif "--disable-static --enable-shared --disable-go --disable-examples --disable-aom --disable-x265 --disable-gdk-pixbuf --disable-rav1e"
./autoconf_generic_build_android.sh libwebp "--disable-shared --enable-static"
./libvips_build_android.sh
#./missing_symbols_fix_build_android.sh
