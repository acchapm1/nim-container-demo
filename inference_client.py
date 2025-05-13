import requests

url = "http://localhost:8000/v1/completions"
payload = {
    "prompt": "The benefits of HPC are",
    "max_tokens": 50
}

response = requests.post(url, json=payload)
print("Response:", response.json())
