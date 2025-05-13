#!/bin/bash
#SBATCH --job-name=nim-demo
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=00:30:00
#SBATCH --output=nim_output.log

module load apptainer

apptainer run --nv llama3-nim.sif
