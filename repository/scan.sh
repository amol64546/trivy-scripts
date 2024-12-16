#!/bin/bash


# Parse flag inputs
if [ "$SCANNER_FLAG" == "misconfig" ]; then
    TRIVY_COMMAND="trivy fs --scanners misconfig $PATH"
elif [ "$SCANNER_FLAG" == "secret" ]; then
    TRIVY_COMMAND="trivy fs --scanners secret $PATH"
elif [ "$SCANNER_FLAG" == "license" ]; then
    TRIVY_COMMAND="trivy fs --scanners license $PATH"
elif [ "$SCANNER_FLAG" == "vuln" ]; then
    TRIVY_COMMAND="trivy fs --scanners vuln $PATH"
else
    TRIVY_COMMAND="trivy fs $PATH"
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
