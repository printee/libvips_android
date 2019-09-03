# Scripts for building libvips for android
## Usage
```bash
git clone https://github.com/libvips_android
cd libvips_android
./build_android.sh
```
 The resulting binary is located in `build/${ARCH}/install/usr/local/lib/libvips.so`, where `${ARCH}` is one of the following: `aarch64-linux-android`, `armv7a-linux-androideabi`, `i686-linux-android`, `x86_64-linux-android`.
 Don't forget to follow the LPGL (libvips) and other licenses inside `libs/*/{LICENSE,COPYING,...}` when using it. The scripts in this repository are MIT licensed, but NOT the dependencies/libraries.

