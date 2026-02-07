variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "Elasticsearch version"
  type        = string
}

variable "http_port" {
  description = "Elasticsearch HTTP port"
  type        = number
}

variable "transport_port" {
  description = "Elasticsearch transport port"
  type        = number
}

variable "data_host_path" {
  description = "Elasticsearch data volume local host path"
  type        = string
}

