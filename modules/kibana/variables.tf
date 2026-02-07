variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "Kibana version"
  type        = string
}

variable "http_port" {
  description = "Kibana HTTP port"
  type        = number
}

variable "elasticsearch_host" {
  description = "Elasticsearch hostname"
  type        = string
  default     = "elasticsearch"
}

variable "elasticsearch_port" {
  description = "Elasticsearch HTTP port"
  type        = number
  default     = 9200
}

