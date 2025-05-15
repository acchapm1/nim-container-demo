#!/bin/bash
set -e  # Exit immediately on error

# Check if CorrDiff container is running
# if ! docker ps --format '{{.Names}}' | grep -q 'corrdiff'; then
#     echo "Error: CorrDiff container is not running" >&2
#     exit 1
# fi
# 
# # Health check with timeout (5 minutes max)
# TIMEOUT=300
# START_TIME=$(date +%s)

echo "Checking NIM health..."
until curl -s -X 'GET' \
  'http://localhost:8000/v1/health/ready' \
  -H 'accept: application/json' | grep -q '"status":"ready"'; do
    sleep 5
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    if [ $ELAPSED -ge $TIMEOUT ]; then
        echo "Health check timed out after 5 minutes" >&2
        exit 1
    fi
done

echo "NIM is healthy and ready for requests"

