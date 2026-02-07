output "beats_url" {
  description = "Logstash Beats input URL"
  value       = "tcp://${var.host_ip}:${var.beats_port}"
}

output "monitoring_url" {
  description = "Logstash monitoring API URL"
  value       = "http://${var.host_ip}:${var.monitoring_port}"
}

output "container_info" {
  description = "Logstash container information"
  value = {
    id     = docker_container.logstash.id
    name   = docker_container.logstash.name
    status = "running"
  }
}