---
theme: ./assets/catppuccin-mocha.json
author: Alan Chapman
date: MMMM dd, YYYY
paging: Slide %d / %d
---

# Accelerating AI Workflows on HPC with NVIDIA NIM and Apptainer

---

## What is NVIDIA NIM?

- Pretrained inference microservices
- Hosted on NVIDIA NGC
- GPU-optimized, containerized deployment

---

## Why Apptainer?

- Secure, rootless
- GPU support with `--nv`
- Ideal for Slurm-based clusters

---

## Demo Plan

1. Pull and run NIM container
2. Query with curl or Python
3. Optional: Slurm batch job
4. Tips and enhancements

---

## Pull the Container

```bash
apptainer pull llama3-nim.sif docker://nvcr.io/nim/meta/llama-3.3-70b-instruct:latest
```

---

## Run the Container

```bash
apptainer run --nv llama3-nim.sif
```

---

## Query with curl

```bash
curl -X POST http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"prompt": "The benefits of HPC are", "max_tokens": 50}'
```

---

## Python Client

(see `inference_client.py` in repo)

---

## Run with Slurm

```bash
sbatch nim_container_job.slurm
```

---

## Optional Enhancements

- Port forwarding
- Proxy with nginx
- Long-lived Slurm jobs

---

## Resources

- NVIDIA NGC
- Apptainer Docs
- Slurm Docs

---
