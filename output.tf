output "network_id" {
  description = "Docker network ID"
  value       = docker_network.devops_network.id
}

output "gitea_url" {
  description = "Gitea web interface URL"
  value       = "http://${var.host_ip}:${var.gitea_http_port}"
}

output "gitea_ssh_url" {
  description = "Gitea SSH URL"
  value       = "ssh://git@${var.host_ip}:${var.gitea_ssh_port}"
}

output "jenkins_url" {
  description = "Jenkins web interface URL"
  value       = "http://${var.host_ip}:${var.jenkins_http_port}"
}

output "artifactory_url" {
  description = "Artifactory web interface URL"
  value       = "http://${var.host_ip}:${var.artifactory_ui_port}"
}

output "sonarqube_url" {
  description = "SonarQube web interface URL"
  value       = "http://${var.host_ip}:${var.sonarqube_http_port}"
}

output "zap_url" {
  description = "ZAP web interface URL"
  value       = "http://${var.host_ip}:${var.zap_http_port}"
}

output "container_info" {
  description = "Container information"
  value = {
    postgres-gitea = {
      id     = docker_container.postgres_gitea.id
      name   = docker_container.postgres_gitea.name
      status = "running"
    }
    gitea = {
      id     = docker_container.gitea.id
      name   = docker_container.gitea.name
      status = "running"
    }
    jenkins = {
      id     = docker_container.jenkins.id
      name   = docker_container.jenkins.name
      status = "running"
    }
    jenkins_agent = {
      id     = docker_container.jenkins_agent.id
      name   = docker_container.jenkins_agent.name
      status = "running"
    }
    postgres-artifactory = {
      id     = docker_container.postgres_artifactory.id
      name   = docker_container.postgres_artifactory.name
      status = "running"
    }
    artifactory = {
      id     = docker_container.artifactory.id
      name   = docker_container.artifactory.name
      status = "running"
    }
    sonarqube = {
      id     = docker_container.sonarqube.id
      name   = docker_container.sonarqube.name
      status = "running"
    }
    zap = {
      id     = docker_container.zap.id
      name   = docker_container.zap.name
      status = "running"
    }
  }
}
