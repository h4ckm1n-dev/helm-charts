#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Helm is installed
if ! command_exists helm; then
    echo -e "${RED}Helm is not installed. Please install Helm first.${NC}"
    echo -e "${YELLOW}Visit https://helm.sh/docs/intro/install/ for installation instructions.${NC}"
    exit 1
fi

echo -e "${BLUE}Setting up Helm repositories...${NC}"

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

echo -e "${YELLOW}Adding HashiCorp repository...${NC}"
helm repo add hashicorp https://helm.releases.hashicorp.com

echo -e "${YELLOW}Adding Cert Manager repository...${NC}"
helm repo add jetstack https://charts.jetstack.io

echo -e "${YELLOW}Updating all repositories...${NC}"
helm repo update

echo -e "${GREEN}Helm repositories setup complete!${NC}"
echo -e "${BLUE}Checking for required permissions...${NC}"

# Check if kubectl is installed
if ! command_exists kubectl; then
    echo -e "${YELLOW}kubectl is not installed. Skipping Kubernetes permission check.${NC}"
else
    # Check if we can access the cluster
    if kubectl get nodes &>/dev/null; then
        echo -e "${GREEN}Kubernetes cluster access confirmed.${NC}"
        
        # Check if cert-manager is installed
        if ! kubectl get crd certificates.cert-manager.io &>/dev/null; then
            echo -e "${YELLOW}Warning: cert-manager CRDs not found.${NC}"
            echo -e "${YELLOW}For TLS support, install cert-manager:${NC}"
            echo -e "${BLUE}kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml${NC}"
        else
            echo -e "${GREEN}cert-manager CRDs found.${NC}"
        fi
    else
        echo -e "${YELLOW}Cannot connect to Kubernetes cluster. Make sure your kubeconfig is properly configured.${NC}"
    fi
fi

echo -e "${GREEN}Setup complete!${NC}"
echo -e "${YELLOW}You can now run the deployment script:${NC}"
echo -e "${BLUE}./scripts/deploy-all.sh${NC}"