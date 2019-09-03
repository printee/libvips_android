#!/bin/bash

SR=/mnt/data2/vips_img/build/linux/install
LP=${SR}/usr/local/lib/

cc \
  -o resize \
  -Os \
  -Wl,--as-needed \
  -Wl,--gc-sections \
  -flto \
  -I${SR}/usr/local/include \
  -I${SR}/usr/local/include \
  -I${SR}/usr/local/include/glib-2.0 \
  -I${SR}/usr/local/lib/glib-2.0/include \
  resize.c \
  ${LP}/libvips.a \
  -lm \
  -ltiff \
  -lgif \
  -pthread \
  ${LP}/libgmodule-2.0.a \
  ${LP}/libgobject-2.0.a \
  ${LP}/libffi.a \
  ${LP}/libexif.a \
  ${LP}/libexpat.a \
  ${LP}/../lib64/libjpeg.a \
  ${LP}/libpng.a \
  ${LP}/libglib-2.0.a \
  -lz \
  -ldl \

strip -s resize
