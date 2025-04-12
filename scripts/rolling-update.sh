#!/bin/bash
set -e
# Don't use pipefail as it can cause the script to exit prematurely

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Default variables
KUBE_CONTEXT=""
TIMEOUT="5m"
PARALLEL=false
ONLY_CORE=false
ONLY_NON_CORE=false

# Help function
function show_help {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -c, --context <context>   Kubernetes context to use (default: current context)"
  echo "  -t, --timeout <timeout>   Timeout for each upgrade (default: 5m)"
  echo "  -p, --parallel            Run updates in parallel"
  echo "  --core-only               Update only core components (sealed-secrets, argo-cd)"
  echo "  --non-core-only           Update only non-core components (skip sealed-secrets, argo-cd)"
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
    -t|--timeout)
      TIMEOUT="$2"
      shift 2
      ;;
    -p|--parallel)
      PARALLEL=true
      shift
      ;;
    --core-only)
      ONLY_CORE=true
      shift
      ;;
    --non-core-only)
      ONLY_NON_CORE=true
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

# Check for conflicting options
if [ "$ONLY_CORE" = true ] && [ "$ONLY_NON_CORE" = true ]; then
  echo -e "${RED}Error: Cannot use both --core-only and --non-core-only together${NC}"
  exit 1
fi

# Set base directory
BASEDIR=$(dirname "$0")/..
cd "$BASEDIR" || exit 1

# Get all currently deployed Helm releases
echo -e "${YELLOW}Finding deployed Helm releases...${NC}"
RELEASES=$(helm list --all-namespaces -o json $KUBE_CONTEXT | jq -r '.[] | "\(.name) \(.namespace)"')

if [ -z "$RELEASES" ]; then
  echo -e "${RED}No Helm releases found. Nothing to update.${NC}"
  exit 0
fi

# Function to update a specific release
function update_release {
  local release_name=$1
  local namespace=$2
  
  # Determine if this is a core component
  is_core=false
  if [[ "$release_name" == "sealed-secrets" || "$release_name" == "argo-cd" ]]; then
    is_core=true
  fi
  
  # Skip based on options
  if [[ "$ONLY_CORE" == true && "$is_core" == false ]]; then
    echo -e "${YELLOW}Skipping non-core component: ${release_name} in namespace ${namespace}${NC}"
    return 0
  fi
  
  if [[ "$ONLY_NON_CORE" == true && "$is_core" == true ]]; then
    echo -e "${YELLOW}Skipping core component: ${release_name} in namespace ${namespace}${NC}"
    return 0
  fi
  
  echo -e "${YELLOW}Rolling update for release ${release_name} in namespace ${namespace}...${NC}"
  
  # Check if we have a matching chart directory
  local chart_dir=""
  if [ -d "$BASEDIR/$release_name" ]; then
    chart_dir="$BASEDIR/$release_name"
    
    # Build dependencies if needed
    if [ -f "$chart_dir/Chart.yaml" ]; then
      echo -e "${YELLOW}Building dependencies for ${release_name}...${NC}"
      (cd "$chart_dir" && helm dependency build) || echo -e "${YELLOW}Warning: Could not build all dependencies for ${release_name}${NC}"
    fi
    
    # Upgrade from local chart
    if helm upgrade "$release_name" "$chart_dir/" \
      --namespace "$namespace" \
      --timeout "$TIMEOUT" \
      $KUBE_CONTEXT; then
      echo -e "${GREEN}Successfully updated ${release_name} in namespace ${namespace}${NC}"
    else
      echo -e "${RED}Failed to update ${release_name} in namespace ${namespace}${NC}"
    fi
  else
    # If no local chart, perform a rollout restart for any deployments
    echo -e "${YELLOW}No matching chart directory found for ${release_name}. Performing rollout restart...${NC}"
    kubectl rollout restart deployment -n "$namespace" -l app.kubernetes.io/instance="$release_name" $KUBE_CONTEXT || echo -e "${YELLOW}No deployments found for ${release_name}${NC}"
  fi
}

# Function to execute updates in parallel or sequentially
function execute_updates {
  local releases="$1"
  
  if [ "$PARALLEL" = true ]; then
    echo -e "${YELLOW}Performing parallel rolling updates...${NC}"
    echo "$releases" | xargs -P 4 -I{} bash -c 'set -e; IFS=" " read -r name namespace <<< "{}"; '"$(declare -f update_release)"'; update_release "$name" "$namespace"'
  else
    echo -e "${YELLOW}Performing sequential rolling updates...${NC}"
    while IFS= read -r line; do
      IFS=" " read -r name namespace <<< "$line"
      update_release "$name" "$namespace"
    done <<< "$RELEASES"
  fi
}

# Main execution
echo -e "${YELLOW}Starting rolling updates for Helm releases...${NC}"
execute_updates "$RELEASES"

echo -e "${GREEN}Rolling updates completed!${NC}"
echo -e "${YELLOW}Note: Some applications may take time to fully initialize.${NC}"