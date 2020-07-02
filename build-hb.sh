#!/bin/sh

set -e

cd /build
export ARCH=aarch64
echo Building for: $ARCH

cd build-$ARCH && \
    ../build-handbrake-gtk.sh && \
    ../strip-install.sh

cp /build/build-$ARCH/HandBrake/build/HandBrakeCLI.exe /build/build-$ARCH/prefix/bin

cd /build/build-$ARCH/prefix && \
    zip -9r /build/ghb-$ARCH.zip *
