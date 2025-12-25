variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "Jenkins version"
  type        = string
}

variable "http_port" {
  description = "Jenkins HTTP port"
  type        = number
}

variable "agent_port" {
  description = "Jenkins agent port"
  type        = number
}

variable "user_id" {
  description = "Jenkins user ID (UID:GID)"
  type        = string
}

variable "host_path" {
  description = "Jenkins data volume local host path"
  type        = string
}

variable "agent_version" {
  description = "Jenkins agent version"
  type        = string
}

variable "agent_host_path" {
  description = "Jenkins agent data volume local host path"
  type        = string
}

variable "agent_name" {
  description = "Jenkins agent name you given at jenkins"
  type        = string
}

variable "agent_secret" {
  description = "Jenkins agent secret fetch after jenkins startsup"
  type        = string
  sensitive   = true
}

