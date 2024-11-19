#!/bin/bash

# Step 1: Validate required environment variables
if [ -z "$REPO_URL" ]; then
  echo "Error: Missing required environment variables."
  exit 1
fi

raw_output=$(trivy repo "$REPO_URL" --format json)

if [ $? -ne 0 ]; then
  echo "Error: Failed to run Trivy scan."
  exit 1
fi

json_output=$(echo "$raw_output" | sed -n '/^{/,$p')


# Function to add a random "id" field to JSON
add_id_to_json() {
  local input_json="$1"
  
  # Generate a random alphanumeric ID
  random_id=$(uuidgen | tr -d '-' | head -c 9)

  # Add the "id" field to the JSON using jq
  updated_json=$(echo "$input_json" | jq --arg id "$random_id" '. + {id: $id}')
  
  echo "$updated_json"
}

# Call the function and print the updated JSON
updated_json=$(add_id_to_json "$json_output")
echo "$updated_json"
