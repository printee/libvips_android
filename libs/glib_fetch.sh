#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

wget https://gitlab.gnome.org/GNOME/glib/-/archive/2.61.2/glib-2.61.2.tar.gz
tar xf glib-2.61.2.tar.gz
rm glib-2.61.2.tar.gz
mv glib-2.61.2 glib
cd glib
patch -sp1 < ../glib-2.61.2.patch
