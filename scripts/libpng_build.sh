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

export CFLAGS="$CFLAGS -fPIC -Os -flto"
./configure "--prefix=${INSTALL_DIR}/linux/install/usr/local" \
  --disable-shared \
  --enable-static
make -j4
make install
make distclean
