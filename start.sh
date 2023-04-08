#!/usr/bin/env bash

DIR=$(realpath $(dirname "$0"))

java -cp "$DIR/app.jar":$CLASSPATH camtesting.App