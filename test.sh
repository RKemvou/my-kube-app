#!/bin/bash

set -e

# Define endpoint (adjust port if needed)
NODE_PORT=30082
ENDPOINT="http://$(minikube ip):${NODE_PORT}"

echo "🔍 Waiting for service to become available..."
sleep 10

echo "🔗 Testing endpoint: ${ENDPOINT}"

# Call the service
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "${ENDPOINT}")

if [ "$RESPONSE" -eq 200 ]; then
  echo "✅ Smoke test passed!"
  exit 0
else
  echo "❌ Smoke test failed with response code: $RESPONSE"
  exit 1
fi

