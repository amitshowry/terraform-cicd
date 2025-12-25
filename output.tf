output "network_id" {
  description = "Docker network ID"
  value       = module.network.network_id
}

output "gitea_url" {
  description = "Gitea web interface URL"
  value       = module.gitea.url
}

output "gitea_ssh_url" {
  description = "Gitea SSH URL"
  value       = module.gitea.ssh_url
}

output "jenkins_url" {
  description = "Jenkins web interface URL"
  value       = module.jenkins.url
}

output "artifactory_url" {
  description = "Artifactory web interface URL"
  value       = module.artifactory.url
}

output "sonarqube_url" {
  description = "SonarQube web interface URL"
  value       = module.sonarqube.url
}

output "zap_url" {
  description = "ZAP web interface URL"
  value       = module.zap.url
}

output "caddy_url" {
  description = "Caddy reverse proxy URL"
  value       = module.caddy.url
}

output "container_info" {
  description = "Container information"
  value = {
    postgres-gitea = module.gitea.postgres_container_info
    gitea = module.gitea.container_info
    jenkins = module.jenkins.container_info.jenkins
    jenkins_agent = module.jenkins.container_info.jenkins_agent
    postgres-artifactory = module.artifactory.postgres_container_info
    artifactory = module.artifactory.container_info
    sonarqube = module.sonarqube.container_info
    zap = module.zap.container_info
    caddy = module.caddy.container_info
  }
}
