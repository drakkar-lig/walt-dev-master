#!/usr/bin/env bash

image="$1"
layer_id="$2"
runp_abs="$(cd ./runp; pwd)"
runpwork_abs="$(cd ./runp_work; pwd)"

docker run -v $runp_abs:/runp -v $runpwork_abs:/runp_work -i --privileged $image /runp/exec_and_compute_diff.sh $layer_id

