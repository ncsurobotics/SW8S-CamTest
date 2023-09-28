#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

# Note: if not running on jetson, may not be able to use omx264enc
#       Use SW encoding instead with libx264
#       x264enc tune=zerolatency speed-preset=ultrafast bitrate=2048000 ! video/x-h264,profile=baseline

gst-launch-1.0 \
    v4l2src device=/dev/video0 ! image/jpeg, width=800, height=600, framerate=30/1 ! \
    jpegdec ! \
    omxh264enc bitrate=2048000 control-rate=variable ! video/x-h264,profile=baseline ! \
    h264parse config_interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=au ! rtspclientsink location=rtsp://127.0.0.1:8554/cam0 &

gst-launch-1.0 \
    v4l2src device=/dev/video1 ! image/jpeg, width=800, height=600, framerate=30/1 ! \
    jpegdec ! \
    omxh264enc bitrate=2048000 control-rate=variable ! video/x-h264,profile=baseline ! \
    h264parse config_interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=au ! rtspclientsink location=rtsp://127.0.0.1:8554/cam1
