#!/bin/bash
set -e
THIS_DIR=$(cd $(dirname "$0"); pwd)
source $THIS_DIR/config.sh

privileged-post-install()
{
    apt-get install -y qemu-user-static
}

enable-cross-arch()
{
    # this will mount binfmt_misc if not done yet,
    # and configure binary interpreters including qemu-arm-static.
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure qemu-user-static
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
        ;;
    "conf-get")
        eval "echo \$$2"
        ;;
    "bash")     # debugging purpose
        bash -i
        ;;
    "*")
        echo "Unknown command." >&2
        ;;
esac

