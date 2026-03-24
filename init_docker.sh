#!/bin/bash

is_jetson() {
    local soc
    soc=$(tr -d '\0' < /proc/device-tree/compatible 2>/dev/null)

    if echo "$soc" | grep -qi "nvidia,tegra"; then
        return 0
    else
        return 1
    fi
}


if is_jetson; then
    echo "This device is an NVIDIA Jetson"
    version="nvcr.io/nvidia/l4t-cuda:12.2.12-runtime"
    docker pull $version
    docker tag $version compiler-base-base:latest
else
    echo "This device is NOT a Jetson"
    echo "Gambling to guess nvidia version"
    version="nvidia/cuda:$(nvidia-smi | grep "CUDA Version" | sed 's/.*CUDA Version: \([0-9.]*\).*/\1/')-devel-ubuntu22.04"
    docker pull $version
    docker tag $version compiler-base-base:latest
fi

#
#