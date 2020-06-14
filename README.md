# handbrake-win-mingw-gtk

The Dockerfile and scripts in this repository will build a version of Handbrake for Windows platform using the GTK UI. The only required software is Docker itself.

As GCC does not support Win64-ARM64 at this time the toolchain used on the Dockerfile is based on MingW with LLVM [https://github.com/mstorsjo/llvm-mingw]

GTK, Handbrake, FFMPEG and other dependencies will be fetched directly from upstream repositories. The majority of build script and configuration changes needed to build for 3 architectures have been submitted upstream.
Patches still not merged upstream will be applied directly from the patches and patches-hb directories.

Users can target aarch64 (ARM64), i686 or x86_64 when building. 

# Building with Docker

docker build -t handbrake --build-arg ARCH=aarch64 .

The archive ghb-aarch64.zip will be created at the / directory in the docker image.

As a convenience we have precompiled binaries built included in this repository, compiled using the script above on a Linux Host.

