#!/bin/bash

# Create namespaces if they don't already exist and deploy/update services

helm upgrade --install prom-stack prom-stack/ --values prom-stack/values.yaml -n prom-stack --create-namespace
helm upgrade --install loki bitnami/grafana-loki --values grafana-loki/values.yaml -n loki --create-namespace
helm upgrade --install blackbox-exporter blackbox/ --values blackbox/values.yaml -n prom-stack --create-namespace
helm upgrade --install sealed-secret sealed-secrets/ --values sealed-secrets/values.yaml -n sealed-secrets --create-namespace
helm upgrade --install argo-cd argo-cd/ --values argo-cd/values.yaml -n argo-cd --create-namespace

# Enable NGINX Ingress controller
minikube addons enable ingress

# Output success message
printf "Minikube deployment stack done :)\n"
