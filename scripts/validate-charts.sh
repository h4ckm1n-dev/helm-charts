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
        echo -e "${RED}Error: $1 is not installed. Please install it first.${NC}"
        exit 1
    fi
}

check_dependency helm
check_dependency yamllint
check_dependency kubeval

# Set base directory
BASEDIR=$(dirname "$0")/..
cd "$BASEDIR" || exit 1

echo -e "${YELLOW}Validating Helm charts...${NC}"

# Lint all YAML files with yamllint
echo -e "${YELLOW}Running yamllint...${NC}"
if yamllint -c .yamllint.yaml .; then
    echo -e "${GREEN}yamllint passed!${NC}"
else
    echo -e "${RED}yamllint failed!${NC}"
    exit 1
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

# Validate Kubernetes manifests with kubeval
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

echo -e "${GREEN}All validation checks passed successfully!${NC}"