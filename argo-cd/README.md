# argo-cd

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | argo-cd | 6.0.12 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.applicationSet.enabled | bool | `true` |  |
| argo-cd.applicationSet.resources.limits.cpu | int | `4` |  |
| argo-cd.applicationSet.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.applicationSet.resources.limits.memory | string | `"500Mi"` |  |
| argo-cd.applicationSet.resources.requests.cpu | string | `"20m"` |  |
| argo-cd.applicationSet.resources.requests.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.applicationSet.resources.requests.memory | string | `"100Mi"` |  |
| argo-cd.applicationSet.serviceAccount.automountServiceAccountToken | bool | `true` |  |
| argo-cd.config.secret.create | bool | `true` |  |
| argo-cd.controller.metrics.enabled | bool | `true` |  |
| argo-cd.controller.metrics.rules.enabled | bool | `true` |  |
| argo-cd.controller.metrics.rules.namespace | string | `"argo-cd"` |  |
| argo-cd.controller.metrics.rules.spec[0].alert | string | `"ArgocdServiceNotSynced"` |  |
| argo-cd.controller.metrics.rules.spec[0].annotations.description | string | `"Service {{`{{ $labels.name }}`}} run by ArgoCD is currently not in sync.\nVALUE = {{`{{ $value }}`}}\nLABELS = {{`{{ $labels }}`}}\n"` |  |
| argo-cd.controller.metrics.rules.spec[0].annotations.summary | string | `"ArgoCD service not synced (container {{`{{ $labels.container }}`}})"` |  |
| argo-cd.controller.metrics.rules.spec[0].expr | string | `"argocd_app_info{sync_status!=\"Synced\"} != 0"` |  |
| argo-cd.controller.metrics.rules.spec[0].for | string | `"2w"` |  |
| argo-cd.controller.metrics.rules.spec[0].labels.severity | string | `"warning"` |  |
| argo-cd.controller.metrics.rules.spec[1].alert | string | `"ArgocdServiceUnhealthy"` |  |
| argo-cd.controller.metrics.rules.spec[1].annotations.description | string | `"Service {{`{{ $labels.name }}`}} run by ArgoCD is currently not healthy.\nVALUE = {{`{{ $value }}`}}\nLABELS = {{`{{ $labels }}`}}\n"` |  |
| argo-cd.controller.metrics.rules.spec[1].annotations.summary | string | `"ArgoCD service unhealthy (container {{`{{ $labels.container }}`}})"` |  |
| argo-cd.controller.metrics.rules.spec[1].expr | string | `"argocd_app_info{health_status!=\"Healthy\"} != 0"` |  |
| argo-cd.controller.metrics.rules.spec[1].for | string | `"15m"` |  |
| argo-cd.controller.metrics.rules.spec[1].labels.severity | string | `"warning"` |  |
| argo-cd.controller.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.controller.resources.limits.cpu | int | `4` |  |
| argo-cd.controller.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.controller.resources.limits.memory | string | `"1800Mi"` |  |
| argo-cd.controller.resources.requests.cpu | string | `"150m"` |  |
| argo-cd.controller.resources.requests.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.controller.resources.requests.memory | string | `"1000Mi"` |  |
| argo-cd.dex.config.connectors[0].config.clientID | string | `"<github-client-id>"` |  |
| argo-cd.dex.config.connectors[0].config.clientSecret | string | `"<github-client-secret>"` |  |
| argo-cd.dex.config.connectors[0].config.redirectURI | string | `"<argo-cd-callback-url-for-dex>"` |  |
| argo-cd.dex.config.connectors[0].id | string | `"github"` |  |
| argo-cd.dex.config.connectors[0].name | string | `"GitHub"` |  |
| argo-cd.dex.config.connectors[0].type | string | `"github"` |  |
| argo-cd.dex.enabled | bool | `true` |  |
| argo-cd.dex.resources.limits.cpu | int | `4` |  |
| argo-cd.dex.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.dex.resources.limits.memory | string | `"1Gi"` |  |
| argo-cd.dex.resources.requests.cpu | string | `"20m"` |  |
| argo-cd.dex.resources.requests.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.dex.resources.requests.memory | string | `"100Mi"` |  |
| argo-cd.redis.master.persistence.enabled | bool | `false` |  |
| argo-cd.redis.master.resources.limits.cpu | int | `4` |  |
| argo-cd.redis.master.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.redis.master.resources.limits.memory | string | `"1Gi"` |  |
| argo-cd.redis.master.resources.requests.cpu | string | `"10m"` |  |
| argo-cd.redis.master.resources.requests.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.redis.master.resources.requests.memory | string | `"50Mi"` |  |
| argo-cd.repoServer.resources.limits.cpu | int | `4` |  |
| argo-cd.repoServer.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.repoServer.resources.limits.memory | string | `"2Gi"` |  |
| argo-cd.repoServer.resources.requests.cpu | string | `"10m"` |  |
| argo-cd.repoServer.resources.requests.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.repoServer.resources.requests.memory | string | `"100Mi"` |  |
| argo-cd.server.resources.limits.cpu | int | `4` |  |
| argo-cd.server.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.server.resources.limits.memory | string | `"1Gi"` |  |
| argo-cd.server.resources.requests.cpu | string | `"20m"` |  |
| argo-cd.server.resources.requests.ephemeral-storage | string | `"1Gi"` |  |
| argo-cd.server.resources.requests.memory | string | `"100Mi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
