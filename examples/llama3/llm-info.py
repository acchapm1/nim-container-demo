#!/usr/bin/env python3

import requests
import subprocess
import json
import shutil
import sys
import platform
from datetime import datetime

def check_endpoint():
    url = "http://localhost:8000/v1/models"
    try:
        r = requests.get(url, timeout=2)
        r.raise_for_status()
        data = r.json()
        model_name = data['data'][0]['id'] if 'data' in data and data['data'] else 'Unknown'
        return ("🧠 Model", model_name)
    except Exception as e:
        return ("❌ API Status", f"Failed to connect to {url}: {e}")

def check_gpu_usage():
    if shutil.which("nvidia-smi") is None:
        return ("⚠️ GPU Info", "nvidia-smi not found (no NVIDIA GPU or drivers not installed)")

    try:
        result = subprocess.run(["nvidia-smi", "--query-gpu=name,memory.used,memory.total,utilization.gpu", "--format=csv,noheader,nounits"], 
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True, text=True)
        output = result.stdout.strip().split('\n')
        gpus = [line.split(', ') for line in output]
        summary = []
        for idx, gpu in enumerate(gpus):
            summary.append(f"GPU {idx}: {gpu[0]}, Memory: {gpu[1]}/{gpu[2]} MiB, Utilization: {gpu[3]}%")
        return ("🎮 GPU Usage", '\n'.join(summary))
    except subprocess.CalledProcessError as e:
        return ("❌ GPU Info", f"Error running nvidia-smi: {e.stderr.strip()}")

def check_system_info():
    try:
        import psutil
    except ImportError:
        return ("⚠️ System Info", "Install `psutil` for system resource stats: pip install psutil")

    mem = psutil.virtual_memory()
    cpu = psutil.cpu_percent(interval=1)
    return ("💻 System Usage", f"CPU Usage: {cpu}%\nMemory Usage: {mem.used // (1024**2)} MiB / {mem.total // (1024**2)} MiB")

def print_summary():
    print(f"🔍 LLM Container Info - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n{'='*40}")

    for check in [check_endpoint, check_gpu_usage, check_system_info]:
        label, info = check()
        print(f"\n{label}:\n{info}")

    print(f"\n🖥️ Host: {platform.node()} ({platform.system()} {platform.release()})")

if __name__ == "__main__":
    print_summary()
