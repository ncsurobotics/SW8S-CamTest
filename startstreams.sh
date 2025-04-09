#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

# Note: if not running on jetson, may not be able to use omx264enc
#       Use SW encoding instead with libx264
#       x264enc tune=zerolatency speed-preset=ultrafast bitrate=2048000 ! video/x-h264,profile=baseline
FRONT_CAM=$(realpath /dev/v4l/by-id/*Front*)
BOTTOM_CAM=$(realpath /dev/v4l/by-id/*Bottom*)
gst-launch-1.0 \
    v4l2src device="$FRONT_CAM" ! image/jpeg, width=640, height=480, framerate=30/1 ! \
    jpegdec ! \
    omxh264enc bitrate=2048000 control-rate=variable ! video/x-h264,profile=baseline ! \
    h264parse config_interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=au ! rtspclientsink location=rtsp://127.0.0.1:8554/front.mp4 &

gst-launch-1.0 \
    v4l2src device="$BOTTOM_CAM" ! image/jpeg, width=640, height=480, framerate=30/1 ! \
    jpegdec ! \
    omxh264enc bitrate=2048000 control-rate=variable ! video/x-h264,profile=baseline ! \
    h264parse config_interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=au ! rtspclientsink location=rtsp://127.0.0.1:8554/bottom.mp4
