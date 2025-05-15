#!/bin/bash

# Default values
FORMAT="markdown"
OUTPUT_FILE=""
DEFAULT_PROMPT="Write a poem about Sparky the Sun Devil."

# Usage function
usage() {
  echo "Usage: $0 --prompt|-p \"Your question here\" [--format|-f json|markdown] [--output|-o filename]"
  exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --prompt|-p)
      PROMPT="$2"
      shift; shift
      ;;
    --format|-f)
      FORMAT="$2"
      shift; shift
      ;;
    --output|-o)
      OUTPUT_FILE="$2"
      shift; shift
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Use default prompt if none provided
if [[ -z "$PROMPT" ]]; then
  #echo "No prompt provided. Using default help prompt."
  PROMPT="$DEFAULT_PROMPT"
fi

# Make API request
RESPONSE=$(curl -s http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"meta/llama-3.3-70b-instruct\",
    \"messages\": [
      {\"role\": \"system\", \"content\": \"You are a helpful assistant.\"},
      {\"role\": \"user\", \"content\": \"$PROMPT\"}
    ],
    \"temperature\": 0.7,
    \"max_tokens\": 512
  }")

# Format output
if [[ "$FORMAT" == "markdown" ]]; then
  OUTPUT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
elif [[ "$FORMAT" == "json" ]]; then
  OUTPUT=$(echo "$RESPONSE" | jq)
else
  echo "Invalid format: $FORMAT. Use 'json' or 'markdown'."
  exit 1
fi

# Output to terminal or file
if [[ -n "$OUTPUT_FILE" ]]; then
  echo "$OUTPUT" > "$OUTPUT_FILE"
  echo "Output saved to $OUTPUT_FILE"
else
  echo -e "\n📨 Prompt:\n$PROMPT"
  echo -e "\n🧠 Response:\n$OUTPUT"
fi
