#!/bin/bash

# Create namespaces if they don't already exist and deploy/update services
helm upgrade --install argo-cd argo-cd/ --values argo-cd/values.yaml -n elk-stack --create-namespace
# Enable NGINX Ingress controller
minikube addons enable ingress

# Output success message
printf "Minikube deployment stack done :)\n"
