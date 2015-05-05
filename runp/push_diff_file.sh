#!/bin/bash
set -e
CID=$(docker ps -l -q) # the container that is being run

# 1- get the diff
# 2- ignore our working files
# 3- ignore /tmp and /run
# 4- ignore aufs file system union artefacts
# 5- build the requested diff_file
docker diff $CID | \
        grep -v "^A \/runp" | \
        grep -v "^[AC] \/run" | \
        grep -v "^[AC] \/tmp" | \
        grep -v "wh\.plnk" > $(dirname $0)/../runp_work/in/diff_file

