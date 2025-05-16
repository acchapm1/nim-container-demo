---
theme:
  name: catppuccin-mocha
  override:
    code:
      alignment: left
      background: false
  footer:
    style: template
    left: "My **name** is {author}"
    center: "_@myhandle_"
    right: "{current_slide} / {total_slides}"
    height: 3
title: Accelerating AI Workflows on HPC with NVIDIA NIM and Apptainer
author: Alan Chapman
---

🚀 Why Apptainer on HPC?
===

- Easy to use
- GPU optimized
- Easy to deploy
- Easy to manage
- Rootless, secure, supports GPUs
- Compatible with Slurm and shared environments
- Docker alternative for clusters

<!-- end_slide -->

Apptainer - pull a container
===

Apptainer is a tool for creating and managing containers on ASU supercomputers. It allows users to create, manage, and run containers with ease.

```bash
# Create a new container and name it lolcow.sif
apptainer pull lolcow.sif shub://GodloveD/lolcow
```

* apptainer pull 
  - Pull a container from a remote registry, such as Docker Hub or Nvidia NGC
* shub://
    - The URL of the container registry
* GodloveD/lolcow
  - The name of the container to pull, in this case, the Whalesay container

<!-- end_slide -->

Apptainer - run a container
===

* Run the container without pulling it first
```bash
apptainer run  shub://GodloveD/lolcow
```
* Run a local container
```bash
apptainer run lolcow.sif
```
* Output of running lolcow container
```bash
 ___________________________________
< Beware of low-flying butterflies. >
 -----------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

<!-- end_slide -->


NVIDIA NIM Containers
===

NVIDIA NIM (NVIDIA Inference Microservices) are pre-built, optimized containers that expose 
powerful AI models through simple REST APIs, making it easy to integrate AI into applications.
Each NIM container is tailored for a specific model and task, including:
- Large Language Models (LLMs)
- Vision models
- Speech models
- Embedding models for retrieval-augmented generation (RAG)

Built on NVIDIA Triton Inference Server and part of the NVIDIA AI Enterprise platform.




This "everything in one box" approach eliminates configuration headaches and ensures models run 
reliably across diverse infrastructure.

<!-- end_slide -->

Nvidia NGC - Pulling Containers
===

Setup:
- Create an account on Nvidia NGC and generate an API key
- Export the API key as an environment variable
```bash
export APPTAINER_DOCKER_USERNAME='$oauthtoken'
export APPTAINER_DOCKER_PASSWORD='<your_ngc_api_key>'
```
Command:
```bash
apptainer pull llama3-nim.sif docker://nvcr.io/nim/meta/llama-3.3-70b-instruct:latest
```

<!-- end_slide -->

Nvidia NIM - Llama 3.3 70B Instruct
===

- Parameters: 70 billion
- Context Window: Up to 128,000 tokens
- Training Data: Over 15 trillion tokens
- Training Techniques: Supervised Fine-Tuning (SFT) and Reinforcement Learning with Human Feedback (RLHF)
- Inference Optimization: Accelerated by TensorRT-LLM for optimized performance on NVIDIA GPUs
- Multilingual Support: Optimized for multilingual dialogue use cases



<!-- end_slide -->

Llama 3.3 70B Instruct - Running the container
===

Running the container is straightforward.  The container is immutable, so we need to bind a cache 
directory to the container.  Here is a bash script to create the cache directory and run the container.

```bash
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
```


<!-- end_slide -->

## Llama 3.3 70B Instruct - Live demo 
===


<!-- end_slide -->


## Evo 2 40B
===

- 405B parameters
- 1.5B context window
- 100K tokens
- 100K vocab

to run the container:

```bash
apptainer run evo2-nim.sif
```
Again this will fail due to the container being immutable and Evo 2 needs to write to a cache directory.

<!-- end_slide -->

## How to find public containers
```bash
# alias on Sol to show all available containers
showsimg
```
* showsimg
  - Lists all the containers available on the system

```bash
# Output of showsimg
afni-22.2.12.sif
alphafold-3.0.0.sif
alphafold-3.0.1.sif
alphafold.sif
amd
anvio_8.sif
aspect.sif
aspect-tester.sif
beast-1.10.4.sif
cactus-2.9.3.sif
``` 

<!-- end_slide -->