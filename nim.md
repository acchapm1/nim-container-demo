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

 - **User-Friendly**: Runs containers without requiring elevated privileges (no root needed)
 - **Secure by Design**: Built for multi-user HPC environments with strong security controls
 - **Compatible with HPC Workflows**: Works seamlessly with MPI, GPUs, Infiniband, and batch schedulers like Slurm
 - **Portability**: Containers are single-file images, easy to share and move across systems
 - **Reproducibility**: Ensures consistent environments for science and research across clusters
 - **Integration with Existing Tools**: Supports binding host filesystems, modules, and software stacks
 - **Supports Docker/OCI**: Can import and run containers from Docker Hub or other OCI registries

<!-- end_slide -->

Apptainer - Pulling a container
===

Apptainer is the tool used for creating and managing containers on ASU supercomputers. It allows users to create, manage, and run containers with ease.

```bash
# Create a new container and name it lolcow.sif
apptainer pull lolcow.sif shub://GodloveD/lolcow
```

This example pulls the lolcow container from the Singularity Hub and names it lolcow.sif.  
There are other container registries available, such as Docker Hub and Nvidia NGC. 
- Docker and Nvidia NGC use docker:// as the prefix for the container registry. 


<!-- end_slide -->

Apptainer - Basic commands
===

* Run the container without pulling it first
```bash
apptainer run  shub://GodloveD/lolcow
```
* Pull the container with a different name
```bash
apptainer pull lolcow.sif shub://GodloveD/lolcow
```
* Run a local container
```bash
apptainer run lolcow.sif
```


<!-- end_slide -->

Apptainer - Inspect a container
===

```bash
apptainer inspect lolcow.sif
```
* To see the definition file the container was built from:
```bash
$ apptainer inspect --deffile lolcow.sif
BootStrap: docker
From: ubuntu:16.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH

%runscript
    fortune | cowsay | lolcat
```
<!-- end_slide -->

NVIDIA NIM Containers
===

**NVIDIA NIM** (NVIDIA Inference Microservices) are pre-built, optimized containers that expose 
powerful AI models through simple REST APIs, making it easy to integrate AI into applications.
Each NIM container is tailored for a specific model and task, including:
- Large Language Models (LLMs)
- Vision models
- Speech models
- Embedding models for retrieval-augmented generation (RAG)

Built on NVIDIA Triton Inference Server and part of the NVIDIA AI Enterprise platform.

This "everything in one box" approach eliminates configuration headaches and ensures models run 
reliably across diverse infrastructure.

To find all the NIM containers available visit:
[NVIDIA NGC](https://catalog.ngc.nvidia.com/)


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

Llama 3.3 70B Instruct - Live demo 
===

- Show the container is running 
- Send a request to the container and show response

<!-- end_slide -->


Nvidia NIM - Earth-2 CorrDiff US
===

NVIDIA Earth-2 Correction Diffusion (CorrDiff) NIM container is a generative AI microservice 
designed to enhance weather forecasting accuracy by downscaling coarse-resolution data into 
high-resolution predictions

- Purpose: CorrDiff downscales 25-km resolution data from the Global Ensemble Forecast System (GEFS) to 3-km resolution, akin to NOAA’s High-Resolution Rapid Refresh (HRRR) model, focusing on the contiguous United States (CONUS).
- Architecture: Employs a two-step generative approach combining a mean machine learning model with a diffusion model to correct and enhance predictions.  ￼
- Input: Accepts 38 surface and atmospheric variables plus forecast lead time, formatted as 4D NumPy arrays.  ￼
- Output: Generates 5D NumPy arrays with 8 variables (e.g., wind speed, temperature, precipitation types) over a 3-km resolution grid.  

<!-- end_slide -->

Containers on ASU HPC clusters
===

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


Discussion
===

- What are the benefits of using NIM containers?
- What are the benefits of using Apptainer?
- What are the benefits of using Docker?
