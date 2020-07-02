#!/bin/sh

set -e

cd /build
export ARCH=aarch64

mkdir -p build-$ARCH && \
    cd build-$ARCH && \
    ../build-gtk.sh && \
    ../copy-pregenerated.sh && \
    ../copy-runtime-dlls.sh 
