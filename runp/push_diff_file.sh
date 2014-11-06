#!/bin/bash
set -e
CID=$(docker ps -l -q) # the container that is being run

# 1- get the diff
# 2- ignore our working files
# 3- ignore aufs file system union artefacts
# 4- build the requested diff_file
docker diff $CID | \
        grep -v "^A \/runp" | \
        grep -v "wh\.plnk" > $(dirname $0)/../runp_work/in/diff_file

