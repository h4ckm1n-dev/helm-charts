module.exports = {
  regexManagers: [
    {
      fileMatch: ["^values\\.yaml$"],
      matchStrings: [
        "https://github\\.com/dependency-check/dependency-check-sonar-plugin/releases/download/(?<currentValue>.*?)/sonar-dependency-check-plugin-\\1\\.jar",
        "https://github\\.com/spotbugs/sonar-findbugs/releases/download/(?<currentValue>.*?)/sonar-findbugs-plugin-\\1\\.jar",
        "https://github\\.com/sbaudoin/sonar-yaml/releases/download/v(?<currentValue>.*?)/sonar-yaml-plugin-\\1\\.jar",
        "https://github\\.com/sonargraph/sonar-sonargraph-integration/releases/download/(?<currentValue>.*?)/sonar-sonargraph-integration-\\1\\.jar"
      ],
      datasourceTemplate: "github-releases",
      depNameTemplate: "sonarqube-plugin",
      versioningTemplate: "semver",
    },
  ],
};
