#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

#VERSION="2.72.4"
VERSION="2.68.4"

wget https://gitlab.gnome.org/GNOME/glib/-/archive/$VERSION/glib-$VERSION.tar.gz
tar xf glib-$VERSION.tar.gz
rm glib-$VERSION.tar.gz
mv glib-$VERSION glib
cd glib
patch -sp1 < ../glib-$VERSION.patch
