#!/bin/bash

# Step 1: Validate required environment variables
# if [ -z "$IMAGE" ]; then
#   echo "Error: Missing required environment variables."
#   exit 1
# fi

raw_output=$(trivy image "$IMAGE" --format json)

if [ $? -ne 0 ]; then
  echo "Error: Failed to run Trivy scan."
  exit 1
fi

updated_json=$(echo "$raw_output" | sed -n '/^{/,$p')

echo "$updated_json"
