#!/bin/bash
DOCKER_IMAGE_MAINTAINER="Etienne Duble <etienne.duble@imag.fr>"
DOCKER_USER="waltplatform"

DEBIAN_VERSION="jessie"
DEBIAN_ARCHIVE_GPG_KEY="8B48AD6246925553"

DOCKER_DEV_MASTER_IMAGE="$DOCKER_USER/dev-master"
DOCKER_DEBIAN_BASE_IMAGE="$DOCKER_USER/debian-base"
DOCKER_DEBIAN_RPI_BUILDER_IMAGE="$DOCKER_USER/rpi-debian-builder"
DOCKER_DEBIAN_RPI_BASE_IMAGE="$DOCKER_USER/rpi-debian-base"
DOCKER_DEBIAN_RPI_IMAGE="$DOCKER_USER/walt-node:rpi-jessie"
DOCKER_RPI_BOOT_BUILDER_IMAGE="$DOCKER_USER/rpi-boot-builder"
DOCKER_RPI_BOOT_IMAGE="$DOCKER_USER/rpi-boot"
DOCKER_SERVER_BUILDER_IMAGE="$DOCKER_USER/server-builder"
DOCKER_SERVER_BASE_FS_IMAGE="$DOCKER_USER/server-base-fs"
DOCKER_SERVER_FS_IMAGE="$DOCKER_USER/server-fs"

RPI_BOOT_KEXEC_VERSION="2.0.3"
RPI_BOOT_BUIDROOT_GIT_TAG="2014.08"

DEBIAN_RPI_REPO_URL="http://mirror.switch.ch/ftp/mirror/raspbian/raspbian"
DEBIAN_RPI_REPO_KEY="http://mirror.switch.ch/ftp/mirror/raspbian/raspbian.public.key"
DEBIAN_RPI_REPO_VERSION="jessie"
DEBIAN_RPI_REPO_SECTIONS="main contrib non-free rpi"
DEBIAN_RPI_KERNEL_REPO="git://github.com/raspberrypi/linux.git"
DEBIAN_RPI_KERNEL_BRANCH_NAME="rpi-3.12.y"
DEBIAN_RPI_KERNEL_COMMIT="15d7e6373f54b99fce2ba5375b75cc11549af751"
# the overlayfs module is needed for the union of filesystems
# (manage the many nodes that may want to write to the same
# exported filesystem; they will write in memory instead)
# the branch is linked to a specific linux kernel
# version (check in the git log).
# From kernel 3.18 onwards, overlayfs is merged in mainline,
# which should simplify this step.
# However, there are issues with kexec when using this new
# kernel versions. (as of may 5, 2015)
DEBIAN_RPI_KERNEL_OVERLAYFS_REPO="https://kernel.googlesource.com/pub/scm/linux/kernel/git/mszeredi/vfs"
DEBIAN_RPI_KERNEL_OVERLAYFS_BRANCH_NAME="overlayfs.v20"

# the firmware repository contains the SoC firmware
# that is loaded on the board startup.
# the firmware is linked to a specific linux kernel
# version (check in the git log)
DEBIAN_RPI_FIRMWARE_VERSION="09c0f5fc8cd9701f01e8e403c398699e1b1a1eb6"

# kernel upgrade notes:
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

HOST_FS_PATH="/host_fs"
RPI_FS_PATH="/rpi_fs"

DEBIAN_RPI_ADDITIONAL_PACKAGES="ssh,sudo,module-init-tools,usbutils,python-pip,udev,lldpd,ntp,vim,texinfo,iputils-ping,python-serial,ntpdate"

RPI_USER="pi"
RPI_USER_PASSWORD="raspberry"

#DEBIAN_RPI_ADDITIONAL_PACKAGES="ssh,sudo,module-init-tools,build-essential,usbutils,python-pip,python-dev,udev,libusb-1.0-0-dev,libtool,automake,lldpd,ntp,vim,texinfo,iputils-ping,python-serial"

SERVER_BASE_ISO_URL="http://ch.releases.ubuntu.com/14.04.1/ubuntu-14.04.1-desktop-amd64.iso"
