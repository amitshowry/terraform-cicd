output "url" {
  description = "SonarQube web interface URL"
  value       = "http://${var.host_ip}:${var.http_port}"
}

output "container_info" {
  description = "SonarQube container information"
  value = {
    id     = docker_container.sonarqube.id
    name   = docker_container.sonarqube.name
    status = "running"
  }
}

