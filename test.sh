#!/bin/bash

set -e

echo "🔍 Waiting for service to become available..."
sleep 10  # give time for pods to start

NODE_PORT=$(kubectl get svc nginx-service -n my-kube-namespace -o jsonpath='{.spec.ports[0].nodePort}')
MINIKUBE_IP=$(minikube ip)
URL="http://$MINIKUBE_IP:$NODE_PORT"

echo "🔗 Testing endpoint: $URL"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "✅ Application responded with 200 OK!"
else
  echo "❌ Application did not respond correctly. Status: $HTTP_STATUS"
  exit 1
fi

