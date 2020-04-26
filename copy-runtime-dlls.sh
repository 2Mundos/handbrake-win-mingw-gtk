#!/bin/sh

set -e

PREFIX=$(pwd)/prefix
: ${ARCH:=x86_64}

TOOLCHAIN=$(dirname $(which $ARCH-w64-mingw32-clang))/..

for i in libc++ libunwind libwinpthread-1; do
	cp $TOOLCHAIN/$ARCH-w64-mingw32/bin/$i.dll $PREFIX/bin
done
