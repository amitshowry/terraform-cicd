variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "Fluentd version"
  type        = string
}

variable "forward_port" {
  description = "Fluentd forward input port"
  type        = number
}
