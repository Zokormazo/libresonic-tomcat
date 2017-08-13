#!/bin/bash
set -e

mkdir /var/libresonic/transcode -p
ln -sf /usr/bin/ffmpeg /var/libresonic/transcode/ffmpeg
chown -R tomcat:tomcat /var/libresonic

exec su-exec tomcat "$@"
