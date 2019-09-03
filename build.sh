#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

#./tools/fetch_all.sh
#./libs/fetch_all.sh
cd scripts
#./glib_build.sh
./libexpat_build.sh
./libexif_build.sh
./libjpeg_build.sh
./libpng_build.sh
./libvips_build.sh
