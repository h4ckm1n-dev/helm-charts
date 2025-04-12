# Helm Charts Repository

Collection of Helm charts for common infrastructure components.

## Build Status
[![Go](https://github.com/h4ckm1n-dev/argo-cd/actions/workflows/helm.yml/badge.svg)](https://github.com/h4ckm1n-dev/argo-cd/actions/workflows/helm.yml)

## Available Charts

- Argo CD
- Blackbox Exporter
- Grafana Loki
- Keycloak
- Kyverno
- Prometheus Stack
- Sealed Secrets
- And more...

## Setup & Deployment

First, set up all required Helm repositories:

```bash
# Add all required repositories
./scripts/setup-repos.sh
```

Then you can deploy all charts at once using the automated deployment script:

```bash
# Deploy everything to your default cluster
./scripts/deploy-all.sh

# Deploy with options
./scripts/deploy-all.sh --context my-cluster --namespace-prefix prod

# Test with dry run (no changes made)
./scripts/deploy-all.sh --dry-run
```

For updating existing deployments:

```bash
# Update all deployed charts
./scripts/rolling-update.sh

# Update only core components (sealed-secrets, argo-cd)
./scripts/rolling-update.sh --core-only 

# Update in parallel for faster deployment
./scripts/rolling-update.sh --parallel
```

## Validation

The repository includes a validation system to ensure chart quality:

```bash
# Validate all charts
./scripts/validate-charts.sh

# Set up pre-commit hooks for development
pre-commit install
```

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this repository.

## Requirements

- Kubernetes cluster
- Helm v3
- kubectl
