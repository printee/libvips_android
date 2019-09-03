#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

./tools/fetch_all.sh
./libs/fetch_all.sh
cd scripts
./glib_build_android.sh
./libexpat_build_android.sh
./libexif_build_android.sh
./libjpeg_build_android.sh
./libpng_build_android.sh
./libvips_build_android.sh
