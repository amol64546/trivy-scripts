#!/bin/bash

# Step 0: Print the input variables
echo "Repository URL: $REPO_URL"
echo "SchemaId: $SCHEMA_ID"
echo "Server URL: $SERVER_URL"


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
echo "Api call to: $SERVER_URL/tf-entity-ingestion/v1.0/schemas/$SCHEMA_ID/instance?upsert=true"
response=$(curl --silent --location \
  "$SERVER_URL/tf-entity-ingestion/v1.0/schemas/$SCHEMA_ID/instance?upsert=true" \
  --header "Content-Type: application/json" \
  --header "Authorization: $BEARER_AUTH" \
  --data "$json_output")
