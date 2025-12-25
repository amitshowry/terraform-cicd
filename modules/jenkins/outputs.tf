output "url" {
  description = "Jenkins web interface URL"
  value       = "http://${var.host_ip}:${var.http_port}"
}

output "container_info" {
  description = "Jenkins container information"
  value = {
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
  }
}

