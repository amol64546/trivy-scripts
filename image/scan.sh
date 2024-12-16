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

# Output the updated JSON
echo "$json_output"
