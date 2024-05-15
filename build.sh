#!/bin/bash

# Create namespaces if they don't already exist and deploy/update services
helm upgrade --install prom-stack prom-stack/ --values prom-stack/values.yaml -n prom-stack --create-namespace --kube-context minikube 
helm upgrade --install loki bitnami/grafana-loki --values grafana-loki/values.yaml -n loki --create-namespace --kube-context minikube 
helm upgrade --install blackbox-exporter blackbox/ --values blackbox/values.yaml -n prom-stack --create-namespace --kube-context minikube 
helm upgrade --install sealed-secret sealed-secrets/ --values sealed-secrets/values.yaml -n kube-system --create-namespace --kube-context minikube 
helm upgrade --install argo-cd argo-cd/ --values argo-cd/values.yaml -n argo-cd --create-namespace --kube-context minikube 

# Enable NGINX Ingress controller
minikube addons enable ingress

# Output success message
printf "Minikube deployment stack done :)\n"
