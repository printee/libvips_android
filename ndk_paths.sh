#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/ndk_path_only.sh"

export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++


# Use for ndk version 29 and up
export LD=$CC
export AR=$TOOLCHAIN/bin/llvm-ar
export AS=$CC
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

# Use for ndk version 23 and up
#export LD=$TOOLCHAIN/bin/ld
#export AR=$TOOLCHAIN/bin/llvm-ar
#export AS=$CC
#export LD=$TOOLCHAIN/bin/ld
#export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
#export STRIP=$TOOLCHAIN/bin/llvm-strip

# Use for ndk version 22 and below
#export LD=$TOOLCHAIN/bin/ld
#export AR=$TOOLCHAIN/bin/$ABI-ar
#export AS=$TOOLCHAIN/bin/$ABI-as
#export RANLIB=$TOOLCHAIN/bin/$ABI-ranlib
#export STRIP=$TOOLCHAIN/bin/$ABI-strip
