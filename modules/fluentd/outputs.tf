output "url" {
  description = "Fluentd forward input URL"
  value       = "tcp://${var.host_ip}:${var.forward_port}"
}

output "container_info" {
  description = "Fluentd container information"
  value = {
    id     = docker_container.fluentd.id
    name   = docker_container.fluentd.name
    status = "running"
  }
}
