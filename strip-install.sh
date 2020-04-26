#!/bin/sh

set -e

PREFIX=$(pwd)/prefix
: ${ARCH:=x86_64}

cd $PREFIX

# Remove development related files
rm -rf include
rm -rf lib/*.a lib/*.la lib/*.def lib/cmake lib/pkgconfig lib/glib-2.0 lib/gdk-pixbuf-*/*/loaders/*.a
# Remove files in bin without a suffix, which are shell scripts
ls bin/* | grep -v '\.' | xargs rm
ls bin/*.exe | grep -v ghb | xargs rm
for i in bin/*.exe bin/*.dll lib/gdk-pixbuf-*/*/loaders/*.dll; do
	$ARCH-w64-mingw32-strip $i
done
rm -rf share/locale

