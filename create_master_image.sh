#!/bin/bash
THIS_DIR=$(cd $(dirname "$0"); pwd)
DOCKER_CACHE_PRESERVE_DIR=$THIS_DIR/.docker_cache

source $THIS_DIR/config.sh
source $THIS_DIR/env.sh
source $THIS_DIR/runp/docker_privileged_build.sh

DEV_MASTER_SCRIPTS_DIR="/scripts_dir"
ENTRY_POINT=$DEV_MASTER_SCRIPTS_DIR/entry_point.sh

TMP_DIR=$(mktemp -d)
cp -rp config.sh env.sh entry_point.sh runp $TMP_DIR

cd $TMP_DIR

cat > Dockerfile << EOF
FROM $DOCKER_DEBIAN_BASE_IMAGE
MAINTAINER $DOCKER_IMAGE_MAINTAINER

ADD config.sh $DEV_MASTER_SCRIPTS_DIR/
ADD env.sh $DEV_MASTER_SCRIPTS_DIR/
ADD entry_point.sh $ENTRY_POINT
RUNP $ENTRY_POINT privileged-post-install
ADD runp/busybox $DEV_MASTER_SCRIPTS_DIR/runp/
ADD runp/docker_privileged_build.sh  $DEV_MASTER_SCRIPTS_DIR/runp/
ADD runp/exec_and_compute_diff.sh  $DEV_MASTER_SCRIPTS_DIR/runp/
ADD runp/push_diff_file.sh $DEV_MASTER_SCRIPTS_DIR/runp/
ADD runp/run_privileged_docker.sh $DEV_MASTER_SCRIPTS_DIR/runp/
ADD runp/run_privileged.exp $DEV_MASTER_SCRIPTS_DIR/runp/
ENTRYPOINT ["$ENTRY_POINT"]
CMD []
EOF

docker-privileged-build "$DOCKER_DEV_MASTER_IMAGE" "$DOCKER_CACHE_PRESERVE_DIR"

cd
rm -rf $TMP_DIR

