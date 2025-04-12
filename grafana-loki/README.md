# Grafana Loki Stack

Ce chart déploie Grafana Loki avec tous les composants nécessaires pour la collecte et l'analyse des logs.

## Configuration du Gateway

Ce déploiement utilise un Gateway NGINX personnalisé pour contourner un problème avec le gateway standard de Bitnami et IPv6.

Le problème principal est lié au format du résolveur DNS dans la configuration NGINX générée par le conteneur Bitnami, qui n'est pas compatible avec les adresses IPv6.

### Solution implémentée

1. Le gateway Bitnami par défaut est désactivé (`gateway.enabled: false`)
2. Un déploiement NGINX standard est utilisé comme alternative
3. Une configuration personnalisée redirecte le trafic vers les composants appropriés:
   - Les requêtes de push (`/loki/api/v1/push`) vers le distributeur
   - Les requêtes de lecture (`/loki/api/*`) vers le query-frontend

## Installation

```bash
# Installation du chart
helm install grafana-loki ./grafana-loki -n grafana-loki --create-namespace

# Si le gateway ne fonctionne pas correctement, appliquer la solution alternative
kubectl apply -f loki-gateway.yaml
```

## Configuration personnalisée

Le chart inclut:

- Rétention des logs configurée à 30 jours
- Stockage persistant de 10Gi
- Ressources optimisées pour un cluster de taille moyenne

## Utilisation avec Grafana

Configurer Grafana pour utiliser Loki comme source de données avec l'URL:

```
http://loki-gateway.grafana-loki.svc.cluster.local
```

## Dépannage

Si le pod `promtail` ne parvient pas à se connecter au gateway, vérifiez:

1. Que le gateway est bien déployé et en état Running
2. Que le service `loki-gateway` est correctement créé
3. Que la connexion réseau entre les pods est fonctionnelle

# grafana-loki

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

## Requirements

| Repository                         | Name         | Version |
| ---------------------------------- | ------------ | ------- |
| https://charts.bitnami.com/bitnami | grafana-loki | 4.0.0   |

## Values

| Key                                           | Type   | Default   | Description |
| --------------------------------------------- | ------ | --------- | ----------- |
| loki.compactor.resources.limits.cpu           | string | `"200m"`  |             |
| loki.compactor.resources.limits.memory        | string | `"512Mi"` |             |
| loki.compactor.resources.requests.cpu         | string | `"100m"`  |             |
| loki.compactor.resources.requests.memory      | string | `"256Mi"` |             |
| loki.distributor.resources.limits.cpu         | string | `"200m"`  |             |
| loki.distributor.resources.limits.memory      | string | `"512Mi"` |             |
| loki.distributor.resources.requests.cpu       | string | `"100m"`  |             |
| loki.distributor.resources.requests.memory    | string | `"256Mi"` |             |
| loki.fullnameOverride                         | string | `"loki"`  |             |
| loki.gateway.resources.limits.cpu             | string | `"200m"`  |             |
| loki.gateway.resources.limits.memory          | string | `"512Mi"` |             |
| loki.gateway.resources.requests.cpu           | string | `"100m"`  |             |
| loki.gateway.resources.requests.memory        | string | `"256Mi"` |             |
| loki.ingester.resources.limits.cpu            | string | `"200m"`  |             |
| loki.ingester.resources.limits.memory         | string | `"512Mi"` |             |
| loki.ingester.resources.requests.cpu          | string | `"100m"`  |             |
| loki.ingester.resources.requests.memory       | string | `"256Mi"` |             |
| loki.promtail.resources.limits.cpu            | string | `"200m"`  |             |
| loki.promtail.resources.limits.memory         | string | `"512Mi"` |             |
| loki.promtail.resources.requests.cpu          | string | `"100m"`  |             |
| loki.promtail.resources.requests.memory       | string | `"256Mi"` |             |
| loki.querier.resources.limits.cpu             | string | `"200m"`  |             |
| loki.querier.resources.limits.memory          | string | `"512Mi"` |             |
| loki.querier.resources.requests.cpu           | string | `"100m"`  |             |
| loki.querier.resources.requests.memory        | string | `"256Mi"` |             |
| loki.queryFrontend.resources.limits.cpu       | string | `"200m"`  |             |
| loki.queryFrontend.resources.limits.memory    | string | `"512Mi"` |             |
| loki.queryFrontend.resources.requests.cpu     | string | `"100m"`  |             |
| loki.queryFrontend.resources.requests.memory  | string | `"256Mi"` |             |
| loki.queryScheduler.resources.limits.cpu      | string | `"200m"`  |             |
| loki.queryScheduler.resources.limits.memory   | string | `"512Mi"` |             |
| loki.queryScheduler.resources.requests.cpu    | string | `"100m"`  |             |
| loki.queryScheduler.resources.requests.memory | string | `"256Mi"` |             |

---

Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
