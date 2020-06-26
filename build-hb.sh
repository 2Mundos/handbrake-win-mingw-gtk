#!/bin/sh

set -e

cd /build
ARCH=aarch64


cd build-$ARCH && \
    ../build-handbrake-gtk.sh && \
    ../strip-install.sh

cp /build/build-$ARCH/HandBrake/build/HandBrakeCLI.exe /build/build-$ARCH/prefix/bin

cd /build/build-$ARCH/prefix && \
    zip -9r /ghb-$ARCH.zip *
