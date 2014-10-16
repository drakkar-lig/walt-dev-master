#!/bin/bash
DOCKER_IMAGE_MAINTAINER="Etienne Duble <etienne.duble@imag.fr>"
DOCKER_USER="waltplatform"

DEBIAN_VERSION="wheezy"
DEBIAN_ARCHIVE_GPG_KEY="8B48AD6246925553"

DOCKER_DEV_MASTER_IMAGE="$DOCKER_USER/dev-master"
DOCKER_DEBIAN_BASE_IMAGE="$DOCKER_USER/debian-base"
DOCKER_DEBIAN_RPI_BUILDER_IMAGE="$DOCKER_USER/rpi-debian-builder"
DOCKER_DEBIAN_RPI_BASE_IMAGE="$DOCKER_USER/rpi-debian-base"
DOCKER_DEBIAN_RPI_IMAGE="$DOCKER_USER/rpi-debian"

DEBIAN_RPI_REPO_URL="http://mirror.switch.ch/ftp/mirror/raspbian/raspbian"
DEBIAN_RPI_REPO_KEY="http://mirror.switch.ch/ftp/mirror/raspbian/raspbian.public.key"
DEBIAN_RPI_REPO_VERSION="wheezy"
DEBIAN_RPI_REPO_SECTIONS="main contrib non-free rpi"

HOST_FS_PATH="/host_fs"
RPI_FS_PATH="/rpi_fs"

DEBIAN_RPI_ADDITIONAL_PACKAGES="ssh,sudo,module-init-tools,usbutils,python-pip,udev,lldpd,ntp,vim,texinfo,iputils-ping,python-serial"
DEBIAN_RPI_BACKPORT_PACKAGES="python-msgpack python-zmq"

RPI_USER="pi"
RPI_USER_PASSWORD="raspberry"

#DEBIAN_RPI_ADDITIONAL_PACKAGES="ssh,sudo,module-init-tools,build-essential,usbutils,python-pip,python-dev,udev,libusb-1.0-0-dev,libtool,automake,lldpd,ntp,vim,texinfo,iputils-ping,python-serial"
