#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up Helm repositories...${NC}"

# Add common Helm repositories used by the charts
echo -e "${YELLOW}Adding Bitnami repository...${NC}"
helm repo add bitnami https://charts.bitnami.com/bitnami

echo -e "${YELLOW}Adding Prometheus Community repository...${NC}"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

echo -e "${YELLOW}Adding Kyverno repository...${NC}"
helm repo add kyverno https://kyverno.github.io/kyverno

echo -e "${YELLOW}Adding Kyverno Policy Reporter repository...${NC}"
helm repo add policy-reporter https://kyverno.github.io/policy-reporter

echo -e "${YELLOW}Adding ArgoCD repository...${NC}"
helm repo add argo https://argoproj.github.io/argo-helm

echo -e "${YELLOW}Adding Sealed Secrets repository...${NC}"
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets

echo -e "${YELLOW}Updating all repositories...${NC}"
helm repo update

echo -e "${GREEN}Helm repositories setup complete!${NC}"
echo -e "${YELLOW}You can now run the deployment script without dependency errors.${NC}"