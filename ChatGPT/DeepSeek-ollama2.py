# ------------------------------------------------------------------------------
# Request to Ollama API Server with GenAI model via request package
#
# Version      Date              Name                 Info
# 1.0          28-January-2025   Denis Astahov        Initial Version
#
# ------------------------------------------------------------------------------
import requests
import json

API_URL = "http://127.0.0.1:11434/api/generate"
MODEL   = "deepseek-r1:8b"
PROMPT  = "Capital city of Armenia?"

payload = {
    "model": MODEL,
    "prompt": PROMPT,
    "stream": False,
    "Content-Type": "application/json"
}


response = requests.post(API_URL, json=payload)
jsondata = json.loads(response.text)
print(jsondata['response'])
