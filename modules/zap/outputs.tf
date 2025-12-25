output "url" {
  description = "ZAP web interface URL"
  value       = "http://${var.host_ip}:${var.http_port}"
}

output "container_info" {
  description = "ZAP container information"
  value = {
    id     = docker_container.zap.id
    name   = docker_container.zap.name
    status = "running"
  }
}

