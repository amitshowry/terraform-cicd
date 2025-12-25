variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "Gitea version"
  type        = string
}

variable "http_port" {
  description = "Gitea HTTP port"
  type        = number
}

variable "ssh_port" {
  description = "Gitea SSH port"
  type        = number
}

variable "disable_registration" {
  description = "Disable public registration"
  type        = string
}

variable "host_path" {
  description = "Gitea data volume local host path"
  type        = string
}

# PostgreSQL variables
variable "postgres_version" {
  description = "Gitea PostgreSQL version"
  type        = string
}

variable "postgres_db" {
  description = "Gitea PostgreSQL database name"
  type        = string
}

variable "postgres_user" {
  description = "Gitea PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "Gitea PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "postgres_host_path" {
  description = "Gitea PostgreSQL data volume local host path"
  type        = string
}

variable "postgres_tcp_port" {
  description = "Gitea PostgreSQL TCP port"
  type        = number
}

