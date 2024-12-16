#!/bin/bash


# Parse flag inputs
if [ "$SCANNER_FLAG" == "misconfig" ]; then
    TRIVY_COMMAND="trivy image --image-config-scanners misconfig $IMAGE"
elif [ "$SCANNER_FLAG" == "secret" ]; then
    TRIVY_COMMAND="trivy image --image-config-scanners secret $IMAGE"
else
    TRIVY_COMMAND="trivy image $IMAGE"
fi

# Run Trivy command and get JSON output
json_output=$(eval "$TRIVY_COMMAND --format json")

# Function to add a random "id" field to JSON
add_id_to_json() {
  local input_json="$1"
  
  # Generate a random alphanumeric ID
  random_id=$(uuidgen | tr -d '-' | head -c 9)

  # Add the "id" field to the JSON using jq
  updated_json=$(echo "$input_json" | jq --arg id "$random_id" '. + {id: $id}')
  
  echo "$updated_json"
}

# Add ID to JSON output
updated_json=$(add_id_to_json "$json_output")

# Output the updated JSON
echo "$updated_json"
