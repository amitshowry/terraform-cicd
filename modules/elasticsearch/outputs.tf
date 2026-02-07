output "url" {
  description = "Elasticsearch REST API URL"
  value       = "http://${var.host_ip}:${var.http_port}"
}

output "container_info" {
  description = "Elasticsearch container information"
  value = {
    id     = docker_container.elasticsearch.id
    name   = docker_container.elasticsearch.name
    status = "running"
  }
}

