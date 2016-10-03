#!/bin/bash
eval "$(docker run waltplatform/dev-master env)"
THIS_DIR=$(cd $(dirname $0); pwd)
TMP_DIR=$(mktemp -d)
BUILD_PACKAGES=$(cat << EOF | tr "\n" " "
subversion make gcc g++ libncurses5-dev bzip2 wget cpio python
unzip bc kpartx dosfstools cdebootstrap debian-archive-keyring
qemu-user-static:i386 git
EOF
)
RPI_TOOLS_REPO="https://github.com/raspberrypi/tools/trunk"
RPI_TOOLS_REPO_DIR="arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64"
RPI_TOOLS_CC_PREFIX="arm-linux-gnueabihf-"

cd $TMP_DIR

cat > Dockerfile << EOF
FROM $DOCKER_DEBIAN_BASE_IMAGE
MAINTAINER $DOCKER_IMAGE_MAINTAINER

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y $BUILD_PACKAGES && \
    apt-get clean

# toolchain
# svn will only dowload last revision, and a specific subdir,
# not the whole history as git would...
RUN svn co -q $RPI_TOOLS_REPO/$RPI_TOOLS_REPO_DIR -- /opt/crosscompiler
ENV PATH /opt/crosscompiler/bin:\$PATH
ENV CROSS_COMPILE /opt/crosscompiler/bin/$RPI_TOOLS_CC_PREFIX
ENV ARCH arm
EOF
docker build -t "$DOCKER_RPI_BUILDER_IMAGE" .
result=$?

rm -rf $TMP_DIR

exit $result


