#!/bin/bash

readonly currentDir="$(pwd)"
readonly dataDir="$currentDir/data"
readonly cacheDir="$dataDir/nim-cache"
readonly hfDir="$dataDir/huggingface"
readonly img="$dataDir/llama3.3.sif"

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export NGC_API_KEY=$(cat ~/.ngc-api-key)

apptainer run \
	--nv \
	--env NGC_API_KEY=$NGC_API_KEY \
	--bind $cacheDir:/opt/nim/.cache \
	$img
