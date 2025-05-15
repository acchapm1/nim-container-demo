#!/bin/bash

export NGC_API_KEY=$(cat ~/.ngc-api-key)
export LOCAL_NIM_CACHE="/scratch/acchapm1/.cache/corrdiff"
export LOCAL_NIM_WORKSPACE="/scratch/acchapm1/.cache/corrdiff/workspace"
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

mkdir -p "$LOCAL_NIM_WORKSPACE"
mkdir -p "$LOCAL_NIM_CACHE"

rm -Rf "$LOCAL_NIM_WORKSPACE/*"

apptainer run --nv \
  --bind "$LOCAL_NIM_CACHE:/opt/nim/.cache" \
  --bind "$LOCAL_NIM_WORKSPACE:/opt/nim/workspace" \
  --env NGC_API_KEY=$NGC_API_KEY \
  corrdiff.nim.sif
