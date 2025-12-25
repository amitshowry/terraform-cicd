variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "image_version" {
  description = "PostgreSQL version"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "user" {
  description = "PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "host_path" {
  description = "PostgreSQL data volume local host path"
  type        = string
}

variable "tcp_port" {
  description = "PostgreSQL TCP port"
  type        = number
}

variable "container_name" {
  description = "PostgreSQL container name"
  type        = string
}

