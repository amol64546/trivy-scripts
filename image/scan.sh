#!/bin/bash

# Parse flag inputs
if [ "$SCANNER_FLAG" == "misconfig" ]; then
    TRIVY_COMMAND="trivy image --scanners misconfig --image-config-scanners misconfig $IMAGE"
elif [ "$SCANNER_FLAG" == "secret" ]; then
    TRIVY_COMMAND="trivy image --scanners secret --image-config-scanners secret $IMAGE"
elif [ "$SCANNER_FLAG" == "vuln" ]; then
    TRIVY_COMMAND="trivy image --scanners vuln $IMAGE"
elif [ "$SCANNER_FLAG" == "license" ]; then
    TRIVY_COMMAND="trivy image --scanners license $IMAGE"
else
    TRIVY_COMMAND="trivy image --scanners vuln,misconfig,secret,license --image-config-scanners misconfig,secret $IMAGE"
fi

# Run Trivy command and get JSON output
json_output=$(eval "$TRIVY_COMMAND --format json")

# Output the updated JSON
echo "$json_output"
