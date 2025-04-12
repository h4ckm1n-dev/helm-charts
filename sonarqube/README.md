# SonarQube Helm Chart

Ce chart déploie SonarQube avec PostgreSQL pour l'analyse de code.

## Configuration automatisée

Ce chart génère automatiquement les secrets nécessaires pour SonarQube et sa base de données PostgreSQL lors du déploiement, ce qui permet un déploiement entièrement automatisé sans intervention manuelle.

### Secrets générés

- `sonarqube`: Contient le mot de passe administrateur de SonarQube

  - `sonarqube-password`: admin

- `sonarqube-postgresql`: Contient les mots de passe pour la base de données PostgreSQL
  - `postgres-password`: postgres (utilisateur root)
  - `password`: postgres (utilisateur sonar)

## Installation

```bash
# Installation du chart
helm install sonarqube ./sonarqube -n sonarqube --create-namespace

# Mise à jour du chart
helm upgrade --install sonarqube ./sonarqube -n sonarqube --create-namespace
```

## Accès

Une fois déployé, SonarQube est accessible via:

- URL: https://sonarqube.h4ckm1n.org
- Utilisateur: admin
- Mot de passe: admin

## Ressources

Le déploiement inclut:

- SonarQube avec 1.5 CPU et 4Gi de mémoire
- PostgreSQL avec 1 CPU et 1Gi de mémoire
- Stockage: 10Gi pour SonarQube et 8Gi pour PostgreSQL

## Plugins pré-installés

- Dependency Check
- FindBugs
- YAML
- Sonargraph Integration
