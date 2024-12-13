#!/bin/bash

updated_json=$(trivy image "$IMAGE" --format json)

echo "$updated_json"
