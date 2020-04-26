#!/bin/sh

set -e

# Copy pregenerated files. If changing versions or configuration, make
# sure to regenerate them by running the built binaries on windows (or wine).

PREFIX=$(pwd)/prefix
GENERATED=$(cd $(dirname $0) && pwd)/generated

cp $GENERATED/loaders.cache $PREFIX/lib/gdk-pixbuf-2.0/2.10.0
cp $GENERATED/gschemas.compiled $PREFIX/share/glib-2.0/schemas
