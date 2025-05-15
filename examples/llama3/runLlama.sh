#!/bin/bash

readonly currentDir="$(pwd)"
readonly dataDir="/scratch/acchapm1/.cache/llama3"
readonly cacheDir="$dataDir/nim-cache"
readonly hfDir="$dataDir/huggingface"

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export NGC_API_KEY=$(cat ~/.ngc-api-key)

apptainer run \
	--nv \
	--env NGC_API_KEY=$NGC_API_KEY \
	--bind $cacheDir:/opt/nim/.cache \
	llama3-nim.sif
