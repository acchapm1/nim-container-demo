#!/usr/bin/env python3

import argparse
import requests
import json
import sys

def parse_args():
    parser = argparse.ArgumentParser(
        description="Query a local LLM chat endpoint and format the response."
    )
    parser.add_argument(
        "-p", "--prompt",
        help="Prompt to send to the LLM. If omitted, shows help for this script.",
        default="Write a poem about Sparky the Sun Devil"
    )
    parser.add_argument("-f", "--format", choices=["json", "markdown"], default="markdown", help="Output format.")
    parser.add_argument("-o", "--output", help="Save output to a file.")
    return parser.parse_args()

def call_llm(prompt):
    url = "http://localhost:8000/v1/chat/completions"
    headers = {"Content-Type": "application/json"}
    payload = {
        "model": "meta/llama-3.3-70b-instruct",
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.7,
        "max_tokens": 512
    }

    try:
        response = requests.post(url, headers=headers, json=payload)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        print(f"Error: {e}")
        sys.exit(1)

def format_output(response, fmt):
    if fmt == "markdown":
        return response["choices"][0]["message"]["content"]
    elif fmt == "json":
        return json.dumps(response, indent=2)
    else:
        raise ValueError(f"Unknown format: {fmt}")

def main():
    args = parse_args()
    response = call_llm(args.prompt)
    output = format_output(response, args.format)
    if args.output:
        with open(args.output, "w") as f:
            f.write(output)
        print(f"📨 Prompt:\n{args.prompt}")
        print(f"\n🧠 Response saved to {args.output}")
    else:
        print(f"\n📨 Prompt:\n{args.prompt}")
        print(f"\n🧠 Response:\n{output}")

if __name__ == "__main__":
    main()
