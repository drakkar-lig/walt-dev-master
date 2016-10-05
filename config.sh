#!/bin/bash
DOCKER_IMAGE_MAINTAINER="Etienne Duble <etienne.duble@imag.fr>"

DEBIAN_VERSION="jessie"
DEBIAN_ARCHIVE_GPG_KEY="8B48AD6246925553"

DOCKER_USER="waltplatform"
DOCKER_DEV_MASTER_IMAGE="$DOCKER_USER/dev-master"
DOCKER_DEBIAN_BASE_IMAGE="$DOCKER_USER/debian-base"
DOCKER_DEBIAN_RPI_BUILDER_IMAGE="$DOCKER_USER/rpi-debian-builder"
DOCKER_DEBIAN_RPI_BASE_IMAGE="$DOCKER_USER/rpi-debian-base"
DOCKER_DEBIAN_RPI_IMAGE="$DOCKER_USER/walt-node:rpi-jessie"
DOCKER_DEFAULT_RPI_IMAGE="$DOCKER_USER/walt-node:rpi-default"
DOCKER_RPI_BUILDER_IMAGE="$DOCKER_USER/rpi-builder"
DOCKER_RPI_BOOT_BUILDER_IMAGE="$DOCKER_USER/rpi-boot-builder"
DOCKER_RPI_BOOT_IMAGE="$DOCKER_USER/rpi-boot"
DOCKER_SERVER_IMAGE="$DOCKER_USER/server"

DEBIAN_SERVER_REPO_URL="http://ftp.ch.debian.org/debian"
DEBIAN_SERVER_REPO_VERSION="jessie"
DEBIAN_SERVER_REPO_SECTIONS="main non-free"

DEBIAN_RPI_REPO_URL="http://mirror.switch.ch/ftp/mirror/raspbian/raspbian"
DEBIAN_RPI_REPO_VERSION="jessie"
DEBIAN_RPI_REPO_SECTIONS="main contrib non-free rpi"

# manual kernel upgrade notes:
# we can retrieve raspbian's running kernel config
# by issuing
# $ zcat /proc/config.gz > /raspbian_config
# then this file can be copied in the kernel compilation
# directory, renamed '.config'.
# After that we issue:
# $ make olddefconfig
# that will set all new config options missing in the existing
# .config file, to their default value.
# Some other options may be changed if needed (see wiki),
# using the menu interface ('make nconfig' or similar).

UBOOT_ARCHIVE_URL="ftp://ftp.denx.de/pub/u-boot/u-boot-2016.09.tar.bz2"
SVN_RPI_BOOT_FILES="https://github.com/raspberrypi/firmware/tags/1.20160620/boot"

INSTALL_UBOOT_SOURCE=" cd /opt && wget -q $UBOOT_ARCHIVE_URL && tar xfj u-boot* && \
                rm u-boot*.bz2 && mv u-boot* u-boot"
ALL_RPI_TYPES="rpi-b rpi-b-plus rpi-2-b rpi-3-b"

