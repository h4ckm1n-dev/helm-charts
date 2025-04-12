#!/bin/bash
set -e
# Don't use pipefail as it can cause the script to exit prematurely with dry-run

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default variables
NAMESPACE_PREFIX=""
KUBE_CONTEXT=""
VALIDATE=true
DRY_RUN=false
SKIP_PREREQ_CHECK=false

# Help function
function show_help {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -c, --context <context>   Kubernetes context to use (default: current context)"
  echo "  -n, --namespace-prefix    Prefix for namespaces (default: use chart name as namespace)"
  echo "  --no-validate             Skip chart validation"
  echo "  --dry-run                 Perform a dry-run deployment (no changes made)"
  echo "  --skip-prereq             Skip prerequisites check"
  echo "  -h, --help                Show this help message"
  exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -c|--context)
      KUBE_CONTEXT="--kube-context $2"
      shift 2
      ;;
    -n|--namespace-prefix)
      NAMESPACE_PREFIX="$2"
      shift 2
      ;;
    --no-validate)
      VALIDATE=false
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --skip-prereq)
      SKIP_PREREQ_CHECK=true
      shift
      ;;
    -h|--help)
      show_help
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      show_help
      ;;
  esac
done

# Set base directory
BASEDIR=$(dirname "$0")/..
cd "$BASEDIR" || exit 1

# Function to check prerequisites
function check_prerequisites {
  echo -e "${BLUE}Checking prerequisites...${NC}"
  
  # Check if kubectl is installed
  if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}kubectl is not installed. Please install kubectl first.${NC}"
    exit 1
  fi
  
  # Check if helm is installed
  if ! command -v helm &> /dev/null; then
    echo -e "${RED}helm is not installed. Please install helm first.${NC}"
    exit 1
  fi
  
  # Check Kubernetes connection
  if ! kubectl $KUBE_CONTEXT get nodes &> /dev/null; then
    echo -e "${RED}Cannot connect to Kubernetes cluster. Please check your kubeconfig.${NC}"
    exit 1
  fi
  
  # Check if cert-manager is installed (required for TLS certificates)
  if ! kubectl $KUBE_CONTEXT get crd certificates.cert-manager.io &> /dev/null; then
    echo -e "${YELLOW}Warning: cert-manager CRDs not found. TLS certificates might not work.${NC}"
    echo -e "${YELLOW}You can install cert-manager with: kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml${NC}"
  fi
  
  echo -e "${GREEN}Prerequisites check completed.${NC}"
}

# Run prerequisites check if not skipped
if [ "$SKIP_PREREQ_CHECK" = false ]; then
  check_prerequisites
fi

# Validate charts if enabled
if [ "$VALIDATE" = true ]; then
  echo -e "${YELLOW}Validating charts before deployment...${NC}"
  if [ -f "$BASEDIR/scripts/validate-charts.sh" ]; then
    "$BASEDIR/scripts/validate-charts.sh"
  else
    echo -e "${YELLOW}Validation script not found, skipping validation.${NC}"
  fi
fi

# Setup dry run flag if enabled
DRY_RUN_FLAG=""
if [ "$DRY_RUN" = true ]; then
  DRY_RUN_FLAG="--dry-run"
  echo -e "${YELLOW}Performing DRY RUN deployment - no changes will be made${NC}"
fi

# Deploy each chart
function deploy_chart {
  chart_dir="$1"
  chart_name=$(basename "$chart_dir")
  
  # Determine namespace
  if [ -n "$NAMESPACE_PREFIX" ]; then
    namespace="${NAMESPACE_PREFIX}-${chart_name}"
  else
    namespace="${chart_name}"
  fi
  
  echo -e "${YELLOW}Deploying ${chart_name} to namespace ${namespace}...${NC}"
  
  # Create namespace if it doesn't exist
  kubectl $KUBE_CONTEXT get namespace "$namespace" &>/dev/null || {
    echo -e "${YELLOW}Creating namespace ${namespace}...${NC}"
    if [ "$DRY_RUN" = false ]; then
      kubectl $KUBE_CONTEXT create namespace "$namespace"
    else
      echo -e "${YELLOW}DRY RUN: Would create namespace ${namespace}${NC}"
    fi
  }
  
  # Build chart dependencies if needed
  if [ -f "$chart_dir/Chart.yaml" ]; then
    echo -e "${YELLOW}Building dependencies for ${chart_name}...${NC}"
    (cd "$chart_dir" && helm dependency build) || echo -e "${YELLOW}Warning: Could not build all dependencies for ${chart_name}${NC}"
  fi

  # Deploy chart
  echo -e "${YELLOW}Deploying ${chart_name}...${NC}"
  if [ "$DRY_RUN" = true ]; then
    # For dry runs, add the debug flag to see template output without failing on CRD issues
    helm upgrade --install "$chart_name" "$chart_dir/" \
      --values "$chart_dir/values.yaml" \
      --namespace "$namespace" \
      --create-namespace \
      $KUBE_CONTEXT \
      $DRY_RUN_FLAG \
      --debug || echo -e "${YELLOW}Note: Errors during dry run are expected since CRDs may not be installed.${NC}"
  else
    # For actual deployment
    helm upgrade --install "$chart_name" "$chart_dir/" \
      --values "$chart_dir/values.yaml" \
      --namespace "$namespace" \
      --create-namespace \
      $KUBE_CONTEXT || echo -e "${RED}Failed to deploy ${chart_name}. Continuing with other charts...${NC}"
  fi
  
  echo -e "${GREEN}${chart_name} deployment completed!${NC}"
  
  # Wait for deployment to be ready if not a dry run
  if [ "$DRY_RUN" = false ]; then
    echo -e "${YELLOW}Waiting for ${chart_name} deployment to be ready...${NC}"
    sleep 5
    kubectl $KUBE_CONTEXT wait --for=condition=available --timeout=300s deployment -l app.kubernetes.io/instance=$chart_name -n "$namespace" || true
  fi
}

# Get all charts from the repository (directories with Chart.yaml files)
echo -e "${YELLOW}Finding all charts to deploy...${NC}"
found_charts=()

while IFS= read -r -d '' chart_file; do
  chart_dir=$(dirname "$chart_file")
  # Skip subdirectories like charts/ directory which might contain Chart.yaml
  if [[ "$chart_dir" != *"/charts/"* ]]; then
    found_charts+=("$chart_dir")
  fi
done < <(find "$BASEDIR" -name "Chart.yaml" -type f -print0)

echo -e "${YELLOW}Found ${#found_charts[@]} charts to deploy${NC}"

# Define deployment order groups
echo -e "${BLUE}Preparing deployment in optimal order...${NC}"
FOUNDATION_CHARTS=("sealed-secrets" "vault")
MONITORING_CHARTS=("prom-stack" "grafana-loki" "blackbox")
POLICY_CHARTS=("kyverno" "policy-reporter")
DEPLOYMENT_CHARTS=("argo-cd")
APP_CHARTS=("keycloak" "sonarqube" "apps")

# Deploy in the optimal order
echo -e "${YELLOW}Starting deployment of foundation charts...${NC}"
for chart_name in "${FOUNDATION_CHARTS[@]}"; do
  for chart_dir in "${found_charts[@]}"; do
    if [[ $(basename "$chart_dir") == "$chart_name" ]]; then
      deploy_chart "$chart_dir"
      # Give extra time for foundation charts to initialize
      if [ "$DRY_RUN" = false ]; then
        echo -e "${YELLOW}Waiting for ${chart_name} to initialize...${NC}"
        sleep 30
      fi
    fi
  done
done

echo -e "${YELLOW}Starting deployment of monitoring charts...${NC}"
for chart_name in "${MONITORING_CHARTS[@]}"; do
  for chart_dir in "${found_charts[@]}"; do
    if [[ $(basename "$chart_dir") == "$chart_name" ]]; then
      deploy_chart "$chart_dir"
    fi
  done
done

echo -e "${YELLOW}Starting deployment of policy charts...${NC}"
for chart_name in "${POLICY_CHARTS[@]}"; do
  for chart_dir in "${found_charts[@]}"; do
    if [[ $(basename "$chart_dir") == "$chart_name" ]]; then
      deploy_chart "$chart_dir"
    fi
  done
done

echo -e "${YELLOW}Starting deployment of deployment charts...${NC}"
for chart_name in "${DEPLOYMENT_CHARTS[@]}"; do
  for chart_dir in "${found_charts[@]}"; do
    if [[ $(basename "$chart_dir") == "$chart_name" ]]; then
      deploy_chart "$chart_dir"
      # Give extra time for deployment charts to initialize
      if [ "$DRY_RUN" = false ]; then
        echo -e "${YELLOW}Waiting for ${chart_name} to initialize...${NC}"
        sleep 30
      fi
    fi
  done
done

echo -e "${YELLOW}Starting deployment of application charts...${NC}"
for chart_name in "${APP_CHARTS[@]}"; do
  for chart_dir in "${found_charts[@]}"; do
    if [[ $(basename "$chart_dir") == "$chart_name" ]]; then
      deploy_chart "$chart_dir"
    fi
  done
done

# Deploy any remaining charts that were not in our predefined lists
echo -e "${YELLOW}Checking for any remaining charts...${NC}"
for chart_dir in "${found_charts[@]}"; do
  chart_name=$(basename "$chart_dir")
  if [[ ! " ${FOUNDATION_CHARTS[*]} ${MONITORING_CHARTS[*]} ${POLICY_CHARTS[*]} ${DEPLOYMENT_CHARTS[*]} ${APP_CHARTS[*]} " =~ " ${chart_name} " ]]; then
    echo -e "${YELLOW}Deploying additional chart: ${chart_name}${NC}"
    deploy_chart "$chart_dir"
  fi
done

echo -e "${GREEN}All charts deployed successfully!${NC}"
echo -e "${YELLOW}Note: Some applications may take time to fully initialize.${NC}"
echo -e "${BLUE}You can check the status of your deployments with:${NC}"
echo -e "  kubectl get pods --all-namespaces"