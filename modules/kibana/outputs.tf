output "url" {
  description = "Kibana web interface URL"
  value       = "http://${var.host_ip}:${var.http_port}"
}

output "container_info" {
  description = "Kibana container information"
  value = {
    id     = docker_container.kibana.id
    name   = docker_container.kibana.name
    status = "running"
  }
}

