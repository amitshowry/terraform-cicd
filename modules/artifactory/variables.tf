variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "Artifactory version"
  type        = string
}

variable "http_port" {
  description = "Artifactory HTTP port"
  type        = number
}

variable "ui_port" {
  description = "Artifactory UI port"
  type        = number
}

variable "host_path" {
  description = "Artifactory data volume local host path"
  type        = string
}

# PostgreSQL variables
variable "postgres_version" {
  description = "Artifactory PostgreSQL version"
  type        = string
}

variable "postgres_db" {
  description = "Artifactory PostgreSQL database name"
  type        = string
}

variable "postgres_user" {
  description = "Artifactory PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "Artifactory PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "postgres_host_path" {
  description = "Artifactory PostgreSQL data volume local host path"
  type        = string
}

variable "postgres_tcp_port" {
  description = "Artifactory PostgreSQL TCP port"
  type        = number
}

