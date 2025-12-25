output "container_id" {
  description = "PostgreSQL container ID"
  value       = docker_container.postgres.id
}

output "container_name" {
  description = "PostgreSQL container name"
  value       = docker_container.postgres.name
}

output "db_host" {
  description = "PostgreSQL database host (container name for service connection)"
  value       = docker_container.postgres.name
}

