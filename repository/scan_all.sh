#!/bin/bash

json_output=$(trivy fs "$REPO_URL" --format json)

# Function to add a random "id" field to JSON
add_id_to_json() {
  local input_json="$1"
  
  # Generate a random alphanumeric ID
  random_id=$(uuidgen | tr -d '-' | head -c 9)

  # Add the "id" field to the JSON using jq
  updated_json=$(echo "$input_json" | jq --arg id "$random_id" '. + {id: $id}')
  
  echo "$updated_json"
}

updated_json=$(add_id_to_json "$json_output")

echo "$updated_json"
