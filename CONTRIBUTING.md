# Contributing to Helm Charts

Thank you for your interest in contributing to our Helm charts repository! This document outlines the process for contributing and the validation steps required.

## Prerequisites

Before you begin, make sure you have the following tools installed:

- [Helm](https://helm.sh/docs/intro/install/)
- [yamllint](https://github.com/adrienverge/yamllint)
- [kubeval](https://github.com/instrumenta/kubeval)
- [pre-commit](https://pre-commit.com/)
- [helm-docs](https://github.com/norwoodj/helm-docs)

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Set up pre-commit hooks:

```bash
pre-commit install
```

## Development Workflow

1. Create a new branch for your changes:

```bash
git checkout -b feature/your-feature-name
```

2. Make your changes to the helm charts
3. Run validation:

```bash
./scripts/validate-charts.sh
```

4. Update documentation with helm-docs:

```bash
helm-docs
```

5. Commit your changes (pre-commit hooks will run automatically)
6. Push to your fork
7. Create a pull request

## Pre-commit Hooks

This repository uses pre-commit hooks to ensure code quality:

- YAML linting
- Helm chart linting
- Kubernetes manifest validation
- Documentation generation

## Chart Requirements

When creating or modifying charts, ensure:

1. Chart version is incremented according to semver
2. Every chart has proper documentation
3. Values files are properly commented
4. Templates use Kubernetes best practices
5. All manifests pass kubeval validation

## Pull Request Process

1. Update the README.md or chart-specific documentation with details of changes
2. Update the version in Chart.yaml following semantic versioning
3. Your PR will be reviewed and CI/CD checks will run automatically
4. Once approved, your PR will be merged