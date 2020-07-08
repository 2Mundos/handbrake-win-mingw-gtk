#!/bin/sh

set -e

cd /build
export ARCH=aarch64
echo Building for: $ARCH

cd build-$ARCH && \
    ../build-handbrake-gtk.sh && \
    ../strip-install.sh

