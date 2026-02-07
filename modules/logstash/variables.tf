variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "Logstash version"
  type        = string
}

variable "beats_port" {
  description = "Logstash Beats input port"
  type        = number
}

variable "http_port" {
  description = "Logstash HTTP input port for Fluentd"
  type        = number
}

variable "monitoring_port" {
  description = "Logstash monitoring API port"
  type        = number
}
