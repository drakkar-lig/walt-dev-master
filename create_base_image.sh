#!/bin/bash
THIS_DIR=$(cd $(dirname "$0"); pwd)
source $THIS_DIR/config.sh

docker build $DOCKER_BUID_OPTIONS -t "$DOCKER_DEBIAN_BASE_IMAGE" - << EOF
FROM debian:$DEBIAN_VERSION
MAINTAINER $DOCKER_IMAGE_MAINTAINER

RUN echo deb http://http.debian.net/debian $DEBIAN_VERSION-backports main >> \
            /etc/apt/sources.list.d/backports.list
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# basic utilities
RUN apt-get update && apt-get upgrade -y && apt-get install -y vim net-tools procps
EOF

