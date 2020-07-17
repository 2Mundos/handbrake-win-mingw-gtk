#!/bin/sh

set -e

cp /build/build-$ARCH/HandBrake/build/HandBrakeCLI.exe /build/build-$ARCH/prefix/bin

cd /build/build-$ARCH/prefix && \
    zip -9r /build/ghb-$ARCH.zip *
