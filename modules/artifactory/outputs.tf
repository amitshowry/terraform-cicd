output "url" {
  description = "Artifactory web interface URL"
  value       = "http://${var.host_ip}:${var.ui_port}"
}

output "container_info" {
  description = "Artifactory container information"
  value = {
    id     = docker_container.artifactory.id
    name   = docker_container.artifactory.name
    status = "running"
  }
}

output "postgres_container_info" {
  description = "PostgreSQL container information"
  value = {
    id     = module.postgres.container_id
    name   = module.postgres.container_name
    status = "running"
  }
}

