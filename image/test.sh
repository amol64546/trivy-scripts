#!/bin/bash

# Docker registry credentials in base64 format (you already have this)
DOCKER_CONFIG_PATH="$HOME/.docker/config.json"

# Save Docker credentials to config.json
echo '{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "Z2FpYW5tb2JpdXM6NXNjNThqX15NUWUpKWJF"
        }
    }
}' > "$DOCKER_CONFIG_PATH"

# Log in to Docker (simulated by config.json being created)
echo "Docker credentials saved in config.json, no need for login command."

# Perform Trivy scan and get the output as JSON
json_output=$(trivy image "$IMAGE" --format json)

# Function to add a random "id" field to JSON
add_id_to_json() {
  local input_json="$1"
  
  # Generate a random alphanumeric ID
  random_id=$(uuidgen | tr -d '-' | head -c 9)

  # Add the "id" field to the JSON using jq
  updated_json=$(echo "$input_json" | jq --arg id "$random_id" '. + {id: $id}')
  
  echo "$updated_json"
}

# Add the random ID to the JSON output
updated_json=$(add_id_to_json "$json_output")

# Print the updated JSON
echo "$updated_json"

# Remove Docker credentials from config.json
echo "Removing Docker credentials from config.json..."

# Option 1: Removing the "auths" section by overwriting config.json with an empty config
echo '{}' > "$DOCKER_CONFIG_PATH"

# Option 2: Alternatively, remove the "auths" key from the existing config
# jq 'del(.auths)' "$DOCKER_CONFIG_PATH" > /tmp/config.json && mv /tmp/config.json "$DOCKER_CONFIG_PATH"

echo "Docker credentials removed from config.json."
