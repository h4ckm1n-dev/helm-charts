#!/bin/bash

set -euo pipefail

helm dependency build
helm template --dry-run --debug --values=values.yaml blackbox-exporter .
