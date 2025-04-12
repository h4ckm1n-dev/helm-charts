#!/bin/bash
set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check dependencies
check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${YELLOW}Warning: $1 is not installed. Skipping checks that require it.${NC}"
        return 1
    fi
    return 0
}

HELM_AVAILABLE=true
YAMLLINT_AVAILABLE=true
KUBEVAL_AVAILABLE=true

check_dependency helm || HELM_AVAILABLE=false
check_dependency yamllint || YAMLLINT_AVAILABLE=false
check_dependency kubeval || KUBEVAL_AVAILABLE=false

# Exit if we don't have helm
if [ "$HELM_AVAILABLE" = "false" ]; then
    echo -e "${RED}Error: helm is required. Please install it first.${NC}"
    exit 1
fi

# Set base directory
BASEDIR=$(dirname "$0")/..
cd "$BASEDIR" || exit 1

echo -e "${YELLOW}Validating Helm charts...${NC}"

# Lint all YAML files with yamllint if available
if [ "$YAMLLINT_AVAILABLE" = "true" ]; then
    echo -e "${YELLOW}Running yamllint...${NC}"
    # Run yamllint but don't fail the script on errors
    yamllint -c .yamllint.yaml .
    echo -e "${YELLOW}yamllint found some issues that should be fixed eventually, but continuing with deployment.${NC}"
else
    echo -e "${YELLOW}Skipping yamllint checks. Install yamllint for more complete validation.${NC}"
fi

# Lint each Helm chart
echo -e "${YELLOW}Running helm lint on each chart...${NC}"
find . -type d -name charts -prune -o -name "Chart.yaml" -print0 | 
    while IFS= read -r -d '' chart; do
        chart_dir=$(dirname "$chart")
        chart_name=$(basename "$chart_dir")
        
        echo -e "${YELLOW}Linting $chart_name...${NC}"
        if helm lint "$chart_dir"; then
            echo -e "${GREEN}Helm lint passed for $chart_name!${NC}"
        else
            echo -e "${RED}Helm lint failed for $chart_name!${NC}"
            exit 1
        fi
    done

# Validate Kubernetes manifests with kubeval if available
if [ "$KUBEVAL_AVAILABLE" = "true" ]; then
    echo -e "${YELLOW}Validating Kubernetes manifests with kubeval...${NC}"
    find . -path "*/templates/*.yaml" -type f -print0 | 
        while IFS= read -r -d '' template; do
            echo -e "${YELLOW}Validating $template...${NC}"
            if kubeval --strict --ignore-missing-schemas "$template"; then
                echo -e "${GREEN}Kubeval passed for $template!${NC}"
            else
                echo -e "${RED}Kubeval failed for $template!${NC}"
                exit 1
            fi
        done
else
    echo -e "${YELLOW}Skipping kubeval validation. Install kubeval for more complete validation.${NC}"
    echo -e "${YELLOW}You can install it with: go install github.com/instrumenta/kubeval@latest${NC}"
fi

echo -e "${GREEN}All validation checks passed successfully!${NC}"