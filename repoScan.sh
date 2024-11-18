#!/bin/bash

echo "Repository URL: $REPO_URL"
echo "SchemaId: $SCHEMA_ID"
echo "Server URL: $SERVER_URL"

if [ -z "$REPO_URL" ] || [ -z "$SCHEMA_ID" ] || [ -z "$SERVER_URL" ] || [ -z "$BEARER_AUTH" ] ; then
  echo "Error: Missing required environment variables."
  exit 1
fi

# Step 1: Run Trivy and capture JSON output
json_output=$(trivy repo "$REPO_URL" --format json)
#echo "$json_output"

# Step 2: Make the API call using the captured JSON output
response=$(curl --silent --location '$SERVER_URL/tf-entity-ingestion/v1.0/schemas/$SCHEMA_ID/instance?upsert=true' \
 --header 'Content-Type: application/json' \
 --header 'Authorization: "$BEARER_AUTH" \
 --data "$json_output")

# Step 3: Print the API response
echo "API Response:"
echo "$response"
