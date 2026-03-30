#!/bin/bash

v4l2-ctl -d /dev/video0 -csensor_mode=4 --set-ctrl=bypass_mode=0,frame_rate=60000000 --set-fmt-video=width=1280,height=720,pixelformat=RG10
./camera.o /tmp/imagepipe