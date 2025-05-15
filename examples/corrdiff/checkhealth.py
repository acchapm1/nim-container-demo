import requests

r = requests.get("http://localhost:8000/v1/health/ready")
if r.status_code == 200:
   print("NIM is healthy!")
else:
   print("NIM is not ready!")
