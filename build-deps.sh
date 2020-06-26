#!/bin/sh

set -e

cd /build
ARCH=aarch64

mkdir build-$ARCH && \
    cd build-$ARCH && \
    ../build-gtk.sh && \
    ../copy-pregenerated.sh && \
    ../copy-runtime-dlls.sh 
