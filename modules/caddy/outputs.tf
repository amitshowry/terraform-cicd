output "url" {
  description = "Caddy reverse proxy URL"
  value       = "http://${var.host_ip}:${var.http_port}"
}

output "container_info" {
  description = "Caddy container information"
  value = {
    id     = docker_container.caddy.id
    name   = docker_container.caddy.name
    status = "running"
  }
}

