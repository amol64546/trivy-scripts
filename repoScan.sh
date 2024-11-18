#!/bin/bash
# Step 1: Validate required environment variables
if [ -z "$REPO_URL" ] || [ -z "$SCHEMA_ID" ] || [ -z "$SERVER_URL" ] || [ -z "$BEARER_AUTH" ]; then
  echo "Error: Missing required environment variables."
  exit 1
fi

# Step 2: Run Trivy and capture JSON output
json_output=$(trivy repo "$REPO_URL" --format json)

if [ $? -ne 0 ]; then
  echo "Error: Failed to run Trivy scan."
  exit 1
fi

# Step 3: Make the API call using the captured JSON output
response=$(curl --silent --location \
  "$SERVER_URL/tf-entity-ingestion/v1.0/schemas/$SCHEMA_ID/instance?upsert=true" \
  --header "Content-Type: application/json" \
  --header "Authorization: $BEARER_AUTH" \
  --data "$json_output")

# Step 3: Print the API response
echo "API Response:"
echo "$response"
