---
theme:
  override:
    code:
      alignment: left
      background: false
title: Simplifying Research Workflows with Containers on Supercomputers
author: Alan Chapman
---

Basic container commands with Apptainer - pull a container
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

Basic container commands with Apptainer - run a container
===

```bash +exec
# Run the container
#apptainer run  shub://GodloveD/lolcow
ping google.com
```
* apptainer run
  - Run a command inside the container without saving it locally

```bash
# Run a local container
apptainer run lolcow.sif

# output of running lolcow container
apptainer run lolcow.sif
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

Building a container
===

```bash
Bootstrap: docker
From: alpine:3.21.3


%runscript
  exec cat /etc/os-release
```
* Bootstrap: docker
  - The base image to use for the container, in this case, Alpine Linux
* From: alpine:3.21.3
  - The specific version of the base image to use
* %runscript
  - The script to run when the container is executed
* exec cat /etc/os-release
  - The command to run inside the container, in this case, printing the OS release information


<!-- end_slide -->

Building a container - run the container
===
```bash
# Run the container
apptainer run alpine.sif
```

```bash 
# Output of running the container
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.21.3
PRETTY_NAME="Alpine Linux v3.21"
HOME_URL="https://alpinelinux.org/"
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"
```

<!-- end_slide -->

Running a container against and Nvidia GPU - PyTorch
===
 
```bash
#!/bin/bash
#SBATCH --job-name=dockerhub
#SBATCH --output=dhout-%j.out
#SBATCH --error=dherr-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=00:15:00
#SBATCH -p htc
#SBATCH -q public
#SBATCH --gres=gpu:a100:1

# env variables
export localData=$(pwd)/data

# Run the training inside the container
apptainer exec --nv \
        -B $localData:/data \
        docker/pyt2.6-dev.sif \
    python3 code/train.py
```

<!-- end_slide -->


Running a container against and Nvidia GPU - Parabricks
===


```bash
#!/bin/bash
#SBATCH -p general
#SBATCH -q public
#SBATCH --mem=128G
#SBATCH -t 0-00:30:00
#SBATCH -G a100:1

export currentdir=$(pwd)
export jobdir=$currentdir/a100_out
mkdir -p $jobdir

apptainer exec --nv parabricks.sif pbrun fq2bam \
         --num-gpus 1 \
         --ref parabricks_sample/Ref/Homo_sapiens_assembly38.fasta \
         --in-fq parabricks_sample/Data/sample_1.fq.gz parabricks_sample/Data/sample_2.fq.gz \
         --out-bam $jobdir/output.bam
```

<!-- end_slide -->


Running a container against and Nvidia GPU - Alphafold 3
===
```bash
#!/bin/bash
#SBATCH -N 1
#SBATCH -c 16
#SBATCH -p htc
#SBATCH -q public
#SBATCH -t 0-00:30:00
#SBATCH -G a100:1

export currentDir=$(pwd)
export PYTHONNOUSERSITE=True
export PARAMS=/data/alphafold/alphafold3/paramaters
export USER_DIR=/scratch/speyer/alphafold3
export DB=/data/alphafold/alphafold3/db_20250131
export CONTAINER=$currentDir/af3.sif

apptainer exec --nv \
     --bind $USsliER_DIR/af_input:/root/af_input \
     --bind $USER_DIR/af_output:/root/af_output \
     --bind $PARAMS:/root/models \
     --bind $DB:/root/public_databases \
     $CONTAINER \
     python /app/alphafold/run_alphafold.py \
     --json_path=/root/af_input/input.json \
     --model_dir=/root/models \
     --db_dir=/root/public_databases \
     --output_dir=/root/af_output
```

<!-- end_slide -->

Containers on Sol 
===

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