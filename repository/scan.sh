#!/bin/bash

# Parse flag inputs
if [ "$SCANNER_FLAG" == "misconfig" ]; then
    TRIVY_COMMAND="trivy repo --scanners misconfig $PATH"
elif [ "$SCANNER_FLAG" == "secret" ]; then
    TRIVY_COMMAND="trivy repo --scanners secret $PATH"
elif [ "$SCANNER_FLAG" == "license" ]; then
    TRIVY_COMMAND="trivy repo --scanners license $PATH"
elif [ "$SCANNER_FLAG" == "vuln" ]; then
    TRIVY_COMMAND="trivy repo --scanners vuln $PATH"
else
    TRIVY_COMMAND="trivy repo --scanners misconfig,vuln,license,secret $PATH"
fi

# Run Trivy command and get JSON output
json_output=$(eval "$TRIVY_COMMAND --format json")

# Output the updated JSON
echo "$json_output"
