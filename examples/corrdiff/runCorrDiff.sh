export LOCAL_NIM_CACHE=$(pwd)/.cache/nim
mkdir -p "$LOCAL_NIM_CACHE"
export LOCAL_NIM_WORKSPACE=$(pwd)/.cache/workspace
mkdir -p "$LOCAL_NIM_WORKSPACE"

export NGC_API_KEY=$(cat ~/.ngc-api-key)

rm -Rf "$LOCAL_NIM_WORKSPACE/*"

apptainer run --nv \
  --bind "$LOCAL_NIM_CACHE:/opt/nim/.cache" \
  --bind "$LOCAL_NIM_WORKSPACE:/opt/nim/workspace" \
  --env NGC_API_KEY=$NGC_API_KEY \
  corrdiff.nim.sif
