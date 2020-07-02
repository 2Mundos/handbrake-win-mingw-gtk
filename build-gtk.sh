#!/bin/sh

set -e

PREFIX=$(pwd)/prefix
PREFIX_NATIVE=$(pwd)/native
PATCHES=$(cd $(dirname $0) && pwd)/patches
export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig
: ${ARCH:=x86_64}
echo Building for: $ARCH

if [ ! -f cross.meson ]; then
	case $ARCH in
	aarch64)
		CPU_FAMILY=aarch64
		CPU=aarch64
		;;
	armv7)
		CPU_FAMILY=arm
		CPU=armv7
		;;
	i686)
		CPU_FAMILY=x86
		CPU=i686
		;;
	x86_64)
		CPU_FAMILY=x86_64
		CPU=x86_64
		;;
	esac
	cat $(dirname $0)/cross.meson.in | sed "s/@ARCH@/$ARCH/;s/@CPU_FAMILY@/$CPU_FAMILY/;s/@CPU@/$CPU/" > cross.meson
fi
CROSS_FILE=$(pwd)/cross.meson

download() {
	src=$1
	filename=$(basename $src)
	packagename=$(echo $filename | sed 's/\.\(tar\|git\).*//')
	name=$(echo $packagename | sed 's/+\?-[[:digit:]\.]*$//')
	if [ ! -d $name ]; then
		[ -e $filename ] || wget $src
		case $src in
		*.tar.xz)
			tar -Jxvf $filename
			;;
		*.tar.bz2)
			tar -jxvf $filename
			;;
		*.tar.gz)
			tar -zxvf $filename
			;;
		esac
		mv $packagename $name
		if [ -d $PATCHES/$name ]; then
			cd $name
			for i in $PATCHES/$name/*.patch; do
				patch -p1 < $i
			done
			cd ..
		fi
	fi
}

build_meson() {
	src=$1
	options=$2
	download $src
	cd $name
	mkdir -p build-mingw
	cd build-mingw
	[ -e build.ninja ] || meson .. --cross-file $CROSS_FILE --prefix $PREFIX -Dlibdir=lib --buildtype release --wrap-mode=nofallback $options
	ninja
	ninja install
	cd ../..
}

build_autotools_native() {
	src=$1
	options=$2
	download $src
	cd $name
	mkdir -p build-native
	cd build-native
	[ -e Makefile ] || ../configure --prefix=$PREFIX_NATIVE $options
	make -j$(nproc)
	make -j$(nproc) install
	cd ../..
}

build_autotools() {
	src=$1
	options=$2
	autoreconf=$3
	download $src
	cd $name
	[ "$autoreconf" != "autoreconf" ] || autoreconf -fiv
	mkdir -p build-mingw
	cd build-mingw
	[ -e Makefile ] || ../configure --host=$ARCH-w64-mingw32 --prefix=$PREFIX $options CPPFLAGS="-I$PREFIX/include" LDFLAGS="-L$PREFIX/lib"
	make -j$(nproc)
	make -j$(nproc) install
	cd ../..
}

build_zlib() {
	src=$1
	options=$2
	download $src
	cd $name
	make -f win32/Makefile.gcc PREFIX=$ARCH-w64-mingw32- SHARED_MODE=1 -j$(nproc)
	make -f win32/Makefile.gcc install SHARED_MODE=1 INCLUDE_PATH=$PREFIX/include LIBRARY_PATH=$PREFIX/lib BINARY_PATH=$PREFIX/bin
	cd ..
}

build_autotools_native http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
export PATH=$PREFIX_NATIVE/bin:$PATH
build_zlib https://www.zlib.net/zlib-1.2.11.tar.xz
build_autotools https://download.sourceforge.net/libpng/libpng-1.6.37.tar.xz --with-zlib-prefix=$PREFIX
build_autotools https://download.savannah.gnu.org/releases/freetype/freetype-2.10.1.tar.gz
build_autotools https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.bz2
build_autotools https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.92.tar.xz --disable-docs
build_autotools https://github.com/libffi/libffi/releases/download/v3.3/libffi-3.3.tar.gz --disable-symvers
build_meson https://download.gnome.org/sources/glib/2.64/glib-2.64.3.tar.xz
build_autotools https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.6.4.tar.xz --with-icu=no autoreconf
build_autotools https://www.cairographics.org/releases/pixman-0.40.0.tar.gz
build_autotools https://www.cairographics.org/releases/cairo-1.16.0.tar.xz
build_meson https://github.com/fribidi/fribidi/releases/download/v1.0.9/fribidi-1.0.9.tar.xz -Ddocs=false
build_meson https://download.gnome.org/sources/pango/1.44/pango-1.44.7.tar.xz -Dintrospection=false
build_meson https://download.gnome.org/sources/gdk-pixbuf/2.40/gdk-pixbuf-2.40.0.tar.xz "-Dgir=false -Dx11=false"
build_meson https://download.gnome.org/sources/atk/2.36/atk-2.36.0.tar.xz -Dintrospection=false
build_meson https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.18.tar.xz -Dintrospection=false
build_autotools https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz
build_autotools https://download.gnome.org/sources/adwaita-icon-theme/3.36/adwaita-icon-theme-3.36.1.tar.xz

echo "On the target system, run gdk-pixbuf-query-loaders > prefix/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache; glib-compile-schemas prefix/share/glib-2.0/schemas"
