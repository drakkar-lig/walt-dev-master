#!/bin/bash
THIS_DIR=$(cd $(dirname "$0"); pwd)
source $THIS_DIR/config.sh
source $THIS_DIR/env.sh

DEV_MASTER_SCRIPTS_DIR="/scripts_dir"
ENTRY_POINT=$DEV_MASTER_SCRIPTS_DIR/entry_point.sh

TMP_DIR=$(mktemp -d)
cp -p config.sh env.sh entry_point.sh $TMP_DIR
cd $TMP_DIR

cat > Dockerfile << EOF
FROM $DOCKER_DEBIAN_BASE_IMAGE
MAINTAINER $DOCKER_IMAGE_MAINTAINER

ADD config.sh $DEV_MASTER_SCRIPTS_DIR/
ADD env.sh $DEV_MASTER_SCRIPTS_DIR/
ADD entry_point.sh $ENTRY_POINT
ENTRYPOINT ["$ENTRY_POINT"]
CMD []
EOF

docker build $DOCKER_BUID_OPTIONS -t "$DOCKER_DEV_MASTER_IMAGE" .

docker run --privileged "$DOCKER_DEV_MASTER_IMAGE" privileged-post-install
docker-commit-and-remove-last-container "$DOCKER_DEV_MASTER_IMAGE"

rm -rf $TMP_DIR
