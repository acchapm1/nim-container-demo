#!/bin/bash

#SBATCH --job-name=nim-demo
#SBATCH -p htc
#SBATCH -q public
#SBATCH -G a100:1
#SBATCH -c 4
#SBATCH --mem=16G
#SBATCH -t 01:00:00
#SBATCH -o out.%j.out
#SBATCH -e err.%j.err

readonly currentDir="$(pwd)"
readonly dataDir="/scratch/acchapm1/.cache/llama3"
readonly cacheDir="$dataDir/nim-cache"
readonly hfDir="$dataDir/huggingface"
readonly img="$currentDir/llama3.3.sif"

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export NGC_API_KEY=$(cat ~/.ngc-api-key)

apptainer run \
        --nv \
        --env NGC_API_KEY=$NGC_API_KEY \
        --bind $cacheDir:/opt/nim/.cache \
        llama3.3.sif
