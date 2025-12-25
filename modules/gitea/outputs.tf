output "url" {
  description = "Gitea web interface URL"
  value       = "http://${var.host_ip}:${var.http_port}"
}

output "ssh_url" {
  description = "Gitea SSH URL"
  value       = "ssh://git@${var.host_ip}:${var.ssh_port}"
}

output "container_info" {
  description = "Gitea container information"
  value = {
    id     = docker_container.gitea.id
    name   = docker_container.gitea.name
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

