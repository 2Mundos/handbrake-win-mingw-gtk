#!/bin/bash

docker run -d \
  -it \
  --name hb \
  --mount type=bind,source="$(pwd)",target=/build \
  handbrake-dev
