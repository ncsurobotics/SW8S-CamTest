#!/usr/bin/env bash

./gradlew jar && \
scp app/build/libs/app.jar start.sh sw8@192.168.2.5:camtest/