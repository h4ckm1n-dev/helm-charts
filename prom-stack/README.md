# kube-prometheus-stack

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://prometheus-community.github.io/helm-charts | kube-prometheus-stack | 58.3.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| kube-prometheus-stack.alertmanager.config.receivers[0].name | string | `"null"` |  |
| kube-prometheus-stack.alertmanager.config.receivers[1].discord_configs[0].send_resolved | bool | `true` |  |
| kube-prometheus-stack.alertmanager.config.receivers[1].discord_configs[0].text | string | `"- 📦 **Pod**: `{{ .CommonLabels.namespace }}/{{ .CommonLabels.pod }}`\n{{- range .Alerts }}\n- 🔖 **Alert**: `{{ .Labels.alertname }}`{{- with .Annotations }}{{- if .message }}{{- if .description }}, {{ .message }}, {{ .description }}{{- else }}, {{ .message }}{{- end }}{{- else if .description }}, {{ .description }}{{- end }}{{- end }}\n{{- if .Annotations.Source }}\n- 🌐 [View in Prometheus]({{ .Annotations.Source }})\n{{- end }}\n{{- if .Annotations.runbook_url }}\n- 📘 [View Runbook]({{ .Annotations.runbook_url }})\n{{- end }}\n- 🔗 [Alert Source]({{ .GeneratorURL }})\n{{- end }}\n---"` |  |
| kube-prometheus-stack.alertmanager.config.receivers[1].discord_configs[0].title | string | `"{{ if eq .Status \"firing\" }} 🚨 Alert {{ else }} ✅ Resolve {{ end }}{{ .CommonLabels.alertname }} 🚧 {{ .CommonLabels.severity }}"` |  |
| kube-prometheus-stack.alertmanager.config.receivers[1].discord_configs[0].webhook_url | string | `"https://discordapp.com/api/webhooks/1209232057251799040/nAcKwRfIMEatjQGJfJbmY93SPvHQXOACefmUjhMcn3anIdkZwPJ8nnbkYi1s7xbmDy5h"` |  |
| kube-prometheus-stack.alertmanager.config.receivers[1].name | string | `"discord"` |  |
| kube-prometheus-stack.alertmanager.config.route.receiver | string | `"discord"` |  |
| kube-prometheus-stack.alertmanager.config.route.routes[0].matchers[0] | string | `"alertname = \"Watchdog\""` |  |
| kube-prometheus-stack.alertmanager.config.route.routes[0].receiver | string | `"null"` |  |
| kube-prometheus-stack.alertmanager.config.route.routes[1].matchers[0] | string | `"alertname =~ \".*\""` |  |
| kube-prometheus-stack.alertmanager.config.route.routes[1].receiver | string | `"discord"` |  |
| kube-prometheus-stack.alertmanager.enabled | bool | `true` |  |
| kube-prometheus-stack.cleanPrometheusOperatorObjectNames | bool | `true` |  |
| kube-prometheus-stack.defaultRules.rules.etcd | bool | `false` |  |
| kube-prometheus-stack.defaultRules.rules.kubeControllerManager | bool | `false` |  |
| kube-prometheus-stack.defaultRules.rules.kubeScheduler | bool | `false` |  |
| kube-prometheus-stack.fullnameOverride | string | `"prom-stack"` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].access | string | `"proxy"` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].editable | bool | `true` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].jsonData.tlsAuth | bool | `false` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].jsonData.tlsAuthWithCACert | bool | `false` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].name | string | `"Loki"` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].type | string | `"loki"` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].url | string | `"http://loki-grafana-loki-gateway.loki.svc.cluster.local"` |  |
| kube-prometheus-stack.grafana.additionalDataSources[0].version | int | `1` |  |
| kube-prometheus-stack.grafana.adminPassword | string | `"admin"` |  |
| kube-prometheus-stack.grafana.adminUser | string | `"admin"` |  |
| kube-prometheus-stack.grafana.assertNoLeakedSecrets | bool | `false` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".apiVersion | int | `1` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].allowUiUpdates | bool | `true` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].disableDeletion | bool | `false` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].editable | bool | `true` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].folder | string | `""` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].name | string | `"default"` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].options.path | string | `"/var/lib/grafana/dashboards/default"` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].orgId | int | `1` |  |
| kube-prometheus-stack.grafana.dashboardProviders."dashboardproviders.yaml".providers[0].type | string | `"file"` |  |
| kube-prometheus-stack.grafana.dashboards.default.blackbox-exporter.gnetId | int | `13659` |  |
| kube-prometheus-stack.grafana.dashboards.default.nginx.datasource | string | `"Prometheus"` |  |
| kube-prometheus-stack.grafana.dashboards.default.nginx.gnetId | int | `6927` |  |
| kube-prometheus-stack.grafana.dashboards.default.node-exporter.datasource | string | `"Prometheus"` |  |
| kube-prometheus-stack.grafana.dashboards.default.node-exporter.gnetId | int | `1860` |  |
| kube-prometheus-stack.grafana.dashboards.default.node-exporter.revision | int | `33` |  |
| kube-prometheus-stack.grafana.dashboards.default.prom-dashboard.datasource | string | `"Prometheus"` |  |
| kube-prometheus-stack.grafana.dashboards.default.prom-dashboard.gnetId | int | `15661` |  |
| kube-prometheus-stack.grafana.dashboards.default.prom-dashboard.revision | int | `1` |  |
| kube-prometheus-stack.grafana.deploymentStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| kube-prometheus-stack.grafana.deploymentStrategy.type | string | `"RollingUpdate"` |  |
| kube-prometheus-stack.grafana.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| kube-prometheus-stack.grafana.ingress.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana.ingress.hosts[0] | string | `"grafana.h4ckm1n.org"` |  |
| kube-prometheus-stack.grafana.ingress.security.admin_force_password_change | bool | `true` |  |
| kube-prometheus-stack.grafana.ingress.security.defaultDashboardsTimezone | string | `"Europe/Paris"` |  |
| kube-prometheus-stack.grafana.ingress.server.root_url | string | `"https://grafana.h4ckm1n.org"` |  |
| kube-prometheus-stack.grafana.persistence.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana.persistence.size | string | `"1Gi"` |  |
| kube-prometheus-stack.grafana.resources.limits.cpu | string | `"1000m"` |  |
| kube-prometheus-stack.grafana.resources.limits.memory | string | `"400Mi"` |  |
| kube-prometheus-stack.grafana.resources.requests.cpu | string | `"20m"` |  |
| kube-prometheus-stack.grafana.resources.requests.memory | string | `"200Mi"` |  |
| kube-prometheus-stack.grafana.sidecar.dashboards.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana.sidecar.datasources.enabled | bool | `true` |  |
| kube-prometheus-stack.kubeControllerManager.enabled | bool | `false` |  |
| kube-prometheus-stack.kubeEtcd.enabled | bool | `false` |  |
| kube-prometheus-stack.kubeScheduler.enabled | bool | `false` |  |
| kube-prometheus-stack.prometheus.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| kube-prometheus-stack.prometheus.ingress.enabled | bool | `true` |  |
| kube-prometheus-stack.prometheus.ingress.hosts[0] | string | `"prometheus.h4ckm1n.org"` |  |
| kube-prometheus-stack.prometheus.resources.limits.cpu | int | `2` |  |
| kube-prometheus-stack.prometheus.resources.limits.memory | string | `"2Gi"` |  |
| kube-prometheus-stack.prometheus.resources.requests.cpu | string | `"150m"` |  |
| kube-prometheus-stack.prometheus.resources.requests.memory | string | `"1Gi"` |  |
| kube-prometheus-stack.prometheusOperator.prometheusConfigReloader.resources.limits.cpu | string | `"50m"` |  |
| kube-prometheus-stack.prometheusOperator.prometheusConfigReloader.resources.limits.memory | string | `"50Mi"` |  |
| kube-prometheus-stack.prometheusOperator.prometheusConfigReloader.resources.requests.cpu | string | `"10m"` |  |
| kube-prometheus-stack.prometheusOperator.prometheusConfigReloader.resources.requests.memory | string | `"10Mi"` |  |
| kube-prometheus-stack.prometheusOperator.resources.limits.cpu | string | `"1000m"` |  |
| kube-prometheus-stack.prometheusOperator.resources.limits.memory | string | `"200Mi"` |  |
| kube-prometheus-stack.prometheusOperator.resources.requests.cpu | string | `"50m"` |  |
| kube-prometheus-stack.prometheusOperator.resources.requests.memory | string | `"100Mi"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].enforcedNamespaceLabel | string | `"enabled"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].job_name | string | `"blackbox-dev"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].metrics_path | string | `"/probe"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].params.module[0] | string | `"http_2xx"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].podMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].probeSelectorNilUsesHelmValues | bool | `false` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[0].source_labels[0] | string | `"__address__"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[0].target_label | string | `"__param_target"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[1].source_labels[0] | string | `"__param_target"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[1].target_label | string | `"instance"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[2].replacement | string | `"blackbox-exporter-gateway.prom-stack.svc.cluster.local"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[2].target_label | string | `"__address__"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[3].source_labels[0] | string | `"__param_module"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[3].target_label | string | `"module"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].retention | string | `"365d"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].retentionSize | string | `"48GiB"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].ruleSelectorNilUsesHelmValues | bool | `false` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].scrapeConfigSelectorNilUsesHelmValues | bool | `false` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].serviceMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].static_configs[0].targets[0] | string | `"google.com"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].storageSpec | string | `nil` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].volumeClaimTemplate.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| kube-prometheus-stack.prometheusSpec.additionalScrapeConfigs[0].volumeClaimTemplate.spec.resources.requests.storage | string | `"50Gi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
