#!/bin/sh

set -e

PREFIX=$(pwd)/prefix
PREFIX_NATIVE=$(pwd)/native
PATCHES=$(cd $(dirname $0) && pwd)/patches-hb
export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig
: ${ARCH:=x86_64}

if [ ! -d HandBrake ]; then
	git clone https://github.com/HandBrake/HandBrake.git
	cd HandBrake
	git checkout ab3ee6e7df7ce2da4effacf1b1420edadaf04ba9
	git am -3 $PATCHES/*.patch
else
	cd HandBrake
fi

mkdir -p build
cd build
../configure --cross=$ARCH-w64-mingw32 --enable-gtk-mingw --prefix=$PREFIX
make -j$(nproc)
make -j$(nproc) install
if [ -e $PREFIX/lib/gdk-pixbuf-2.0/*/loaders.cache ]; then
	mkdir -p $PREFIX/bin/ghb.exe.local
	cp $PREFIX/lib/gdk-pixbuf-2.0/*/loaders.cache $PREFIX/bin/ghb.exe.local
fi
