#!/bin/bash
set -e
THIS_DIR=$(cd $(dirname "$0"); pwd)
source $THIS_DIR/config.sh

privileged-post-install()
{
    apt-get update && apt-get install -y qemu-user-static
    umount /proc/sys/fs/binfmt_misc
}

enable-cross-arch()
{
    # this will temporarily remount binfmt_misc
    # and configure binary interpreters including qemu-arm-static.
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure qemu-user-static
    umount /proc/sys/fs/binfmt_misc
}

case "$1" in
    "privileged-post-install")
        privileged-post-install
        ;;
    "enable-cross-arch")
        enable-cross-arch
        ;;
    "conf")
        cat "$THIS_DIR/config.sh"
        ;;
    "env")
        cat "$THIS_DIR/config.sh"
        cat "$THIS_DIR/env.sh"
        cat "$THIS_DIR/runp/docker_privileged_build.sh"
        echo "set +ex"  # disable any error or debug env config
        ;;
    "conf-get")
        # to be used in Makefile, e.g.
        # DOCKER_SERVER_IMAGE=$(shell docker run waltplatform/dev-master \
        #                    conf-get DOCKER_SERVER_IMAGE)
        eval "echo \$$2"
        ;;
    "runp-tools-archive")
        cd "$THIS_DIR" && tar cfz - runp
        ;;
    "bash")     # debugging purpose
        bash -i
        ;;
    "*")
        echo "Unknown command." >&2
        ;;
esac

