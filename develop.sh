#!/bin/bash
set -e
docker build -f DockerFile --target main -t jetson:main .

# Main:
docker run --rm -it --volume ./:/src -e DISPLAY=$DISPLAY  -v /tmp/.X11-unix:/tmp/.X11-unix jetson:main 
#docker run --rm --gpus all img:main

# Debug:
# docker run --rm --gpus all -it --entrypoint sh matrix:main
#docker build --progress=plain -f DockerFile --target main -t $NAME:main .
