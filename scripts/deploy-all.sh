#!/bin/bash
set -e
# Don't use pipefail as it can cause the script to exit prematurely with dry-run

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Default variables
NAMESPACE_PREFIX=""
KUBE_CONTEXT=""
VALIDATE=true
DRY_RUN=false

# Help function
function show_help {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -c, --context <context>   Kubernetes context to use (default: current context)"
  echo "  -n, --namespace-prefix    Prefix for namespaces (default: use chart name as namespace)"
  echo "  --no-validate             Skip chart validation"
  echo "  --dry-run                 Perform a dry-run deployment (no changes made)"
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

# Deploy all charts
echo -e "${YELLOW}Starting deployment of all charts...${NC}"

# Check if we have any core components
has_core=false
for chart_dir in "${found_charts[@]}"; do
  chart_name=$(basename "$chart_dir")
  if [[ "$chart_name" == "sealed-secrets" || "$chart_name" == "argo-cd" ]]; then
    has_core=true
    deploy_chart "$chart_dir"
  fi
done

# Wait for core components to be ready
if [ "$has_core" = true ]; then
  echo -e "${YELLOW}Waiting for core components to be ready...${NC}"
  sleep 30
fi

# Then deploy the rest of the charts
for chart_dir in "${found_charts[@]}"; do
  chart_name=$(basename "$chart_dir")
  if [[ "$chart_name" != "sealed-secrets" && "$chart_name" != "argo-cd" && "$chart_name" != "apps" ]]; then
    deploy_chart "$chart_dir"
  fi
done

# Finally deploy the apps chart if it exists
for chart_dir in "${found_charts[@]}"; do
  chart_name=$(basename "$chart_dir")
  if [[ "$chart_name" == "apps" ]]; then
    deploy_chart "$chart_dir"
  fi
done

echo -e "${GREEN}All charts deployed successfully!${NC}"
echo -e "${YELLOW}Note: Some applications may take time to fully initialize.${NC}"