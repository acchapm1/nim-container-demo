import requests

url = "http://localhost:8000/v1/infer"
files = {"input_array": ("input_array", open("corrdiff_inputs.npy", "rb"))}
data = {"samples": 2, "steps": 14, "seed": 0}
headers = {"accept": "application/x-tar"}

r = requests.post(url, headers=headers, data=data, files=files, timeout=180)
if r.status_code == 200:
    with open("output.tar", "wb") as tar:
        tar.write(r.content)
else:
    raise Exception(r.content)

